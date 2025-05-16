import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import '../../controller/attendance_controller.dart';

class ViewAttendanceScreen extends StatelessWidget {
  const ViewAttendanceScreen({super.key, required this.id, this.attendance});
  final String id;
  final Attendance? attendance;
  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());
    c.getAttendance(LocalStorage().readUser().admissionNo!);
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Attendance'),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Obx(() {
              if (c.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              } else if (c.attendanceList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/empty_list.json', height: 200),
                      SizedBox(height: 20),
                      Text(
                        'No data available',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'There’s nothing to show here at the moment.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return DataTable(
                columnSpacing: 15,
                columns: [
                  DataColumn(label: _buildTableCell('Date', isHeader: true)),
                  DataColumn(
                      label: _buildTableCell('Program Name', isHeader: true)),
                  DataColumn(label: _buildTableCell('Hours', isHeader: true)),
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
                      DataCell(Text(data.name ?? '')),
                      DataCell(Text(data.hours.toString())),
                      if (LocalStorage().readUser().role != 'vol')
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => c.deleteAttendance(data.id ?? 0),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 100),
            Obx(() => Center(
                    child: Text(
                  "   Total hours attended: ${c.totalHours}\nTotal programs attended: ${c.totalPrograms}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ))),
          ],
        ));
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
    return Text(
      text,
      style: TextStyle(
        fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
    );
  }
}
