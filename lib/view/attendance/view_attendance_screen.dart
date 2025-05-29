import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import '../../controller/attendance_controller.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({super.key, required this.id, this.attendance});
  final String id;
  final Attendance? attendance;
  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());

    return Scaffold(
        appBar: AppBar(
          title: const Text('View Attendance'),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))
          ],
        ),
        body: Obx(() {
          if (c.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (c.attendanceList.isEmpty) {
            return SizedBox(
              height: double.maxFinite,
              child: CustomWidgets.noDataWidget,
            );
          }
          return ListView(
            padding: EdgeInsets.all(10),
            children: [
              DataTable(
                columnSpacing: 15,
                columns: [
                  DataColumn(
                      label: _buildTableCell(
                    'Date',
                    isHeader: true,
                  )),
                  DataColumn(label: _buildTableCell('Name', isHeader: true)),
                  DataColumn(label: _buildTableCell('Hours', isHeader: true)),
                  if (LocalStorage().readUser().role != 'vol')
                    DataColumn(
                        label: (LocalStorage().readUser().role != 'vol')
                            ? _buildTableCell('Remove', isHeader: true)
                            : SizedBox())
                ],
                border: TableBorder.all(
                    style: BorderStyle.none,
                    color: Theme.of(context).primaryColor),
                rows: c.attendanceList.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        data.date != null
                            ? DateFormat.yMMMd().format(data.date!)
                            : "N/A",
                      )),
                      DataCell(Expanded(child: Text(data.name ?? ''))),
                      DataCell(Text(data.hours.toString())),
                      if (LocalStorage().readUser().role != 'vol')
                        DataCell(
                          IconButton(
                            icon: c.isLoading.isTrue
                                ? Center(child: CircularProgressIndicator())
                                : Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              CustomWidgets().showConfirmationDialog(
                                  title: "Delete Attendance",
                                  message:
                                      "Are you sure you want to delete attendance for the program?",
                                  onConfirm: () {
                                    c.deleteAttendance(data.id ?? 0);
                                  });
                            },
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
