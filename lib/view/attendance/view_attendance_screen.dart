import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/common_pages/loading.dart';
import 'package:nss/view/common_pages/no_data.dart';
import '../../controller/attendance_controller.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({
    super.key,
    required this.id,
    required this.isViewAttendance,
  });
  final bool isViewAttendance;
  final String id;

  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());
    c.getAttendance(id);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Obx(() => (!c.isLoading.value)
              ? AppBar(
                  title: const Text('View Attendance'),
                  backgroundColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                  foregroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  actions: [
                    IconButton(
                        onPressed: () => c.getAttendance(id),
                        icon: Icon(Icons.refresh))
                  ],
                )
              : SizedBox()),
        ),
        body: Obx(() {
          if (c.isAttendanceLoading.isTrue) {
            return LoadingScreen();
          } else if (c.attendanceList.isEmpty) {
            return SizedBox(
              height: double.maxFinite,
              child: NoDataPage(),
            );
          }
          return ListView(
            padding: EdgeInsets.all(10),
            children: [
              DataTable(
                columnSpacing: 15,
                columns: [
                  DataColumn(label: _buildTableCell('Date', isHeader: true)),
                  DataColumn(label: _buildTableCell('Name', isHeader: true)),
                  DataColumn(label: _buildTableCell('Hours', isHeader: true)),
                  if (!isViewAttendance)
                    DataColumn(label: _buildTableCell('Remove', isHeader: true))
                ],
                border: TableBorder.all(
                    style: BorderStyle.none,
                    color: Theme.of(context).primaryColor),
                rows: c.attendanceList.asMap().entries.map((data) {
                  final index = data.key;
                  final rowData = data.value;
                  final isEven = index % 2 == 0;

                  return DataRow(
                    color: WidgetStatePropertyAll(isEven
                        ? Colors.grey[200]
                        : Theme.of(context).colorScheme.surface),
                    cells: [
                      DataCell(Text(
                        data.value.date != null
                            ? DateFormat.yMMMd().format(data.value.date!)
                            : "N/A",
                      )),
                      DataCell(Text(rowData.name ?? '')),
                      DataCell(Text(rowData.hours.toString())),
                      if (!isViewAttendance)
                        DataCell(
                          IconButton(
                            icon: c.isLoading.isTrue
                                ? Center(child: CircularProgressIndicator())
                                : Icon(Icons.delete, color: Colors.red),
                            onPressed: () => CustomWidgets()
                                .showConfirmationDialog(
                                    title: "Delete Attendance",
                                    message:
                                        "Are you sure you want to delete attendance for the program?",
                                    onConfirm: () => c.deleteAttendance(rowData.id ?? 0)),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 100),
              Obx(() => Center(
                      child: Text(
                    "   Total hours attended: ${c.totalHours}\nTotal programs attended: ${c.totalPrograms}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )))
            ],
          );
        }));
  }

  TableRow buildDataRow(
      {required Attendance data, required AttendanceController c}) {
    return TableRow(
      children: [
        _buildTableCell(
          data.date != null ? DateFormat.yMMMd().format(data.date!) : "N/A",
        ),
        _buildTableCell(data.name ?? ''),
        _buildTableCell(data.hours.toString()),
        ElevatedButton(
            onPressed: () => c.deleteAttendance(data.id!),
            child: Icon(
              Icons.remove_circle,
              color: Colors.teal,
            ))
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }
}
