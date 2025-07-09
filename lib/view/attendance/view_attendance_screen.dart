import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/database/local_storage.dart';
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
              child: NoDataPage(title: 'Attendance not found'),
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
                  if (LocalStorage.isAdmin)
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
                      if (LocalStorage.isAdmin)
                        DataCell(Text(rowData.hours.toString())),
                      if (!isViewAttendance)
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.close_sharp, color: Colors.red),
                            onPressed: () => CustomWidgets().showConfirmationDialog(
                                title: "Delete Attendance",
                                message:
                                    "Are you sure you want to delete attendance for the program?",
                                onConfirm: () =>
                                    c.deleteAttendance(rowData.id ?? 0),
                                data: c.isLoading.isTrue
                                    ? Center(child: CircularProgressIndicator())
                                    : Text('Confirm')),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
              Obx(() => Card(
                    elevation: 4,
                    color: Color.fromARGB(255, 231, 227, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: (LocalStorage.isAdmin)
                            ? (MainAxisAlignment.start)
                            : MainAxisAlignment.center,
                        children: [
                          if (LocalStorage.isAdmin)
                            Column(
                              children: [
                                Text(
                                  "Total Hours Attended",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "${c.totalHours}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          if (LocalStorage.isAdmin) const SizedBox(width: 20),
                          Flexible(
                            child: Column(
                              children: [
                                Text(
                                  "Total Programs Attended",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${c.totalPrograms}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          );
        }));
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
