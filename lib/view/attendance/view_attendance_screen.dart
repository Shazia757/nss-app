import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

    c.getAttendance(id);
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(Icons.error,
                            color: Theme.of(context).primaryColor),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Attendance not found",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.35),
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.10),
                  if (LocalStorage().readUser().role != 'vol')
                    3: FixedColumnWidth(
                        MediaQuery.of(context).size.width * 0.10),
                },
                border: TableBorder.all(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.teal),
                children: [
                  TableRow(
                    children: [
                      _buildTableCell('Date', isHeader: true),
                      _buildTableCell('Program Name', isHeader: true),
                      _buildTableCell('Hours', isHeader: true),
                      if (LocalStorage().readUser().role != 'vol')
                        _buildTableCell('Remove', isHeader: true),
                    ],
                  ),
                  ...c.attendanceList.map(
                    (e) => _buildDataRow(data: e, c: c
                        // date: e.date != null
                        //     ? DateFormat.yMMMd().format(e.date!)
                        //     : "N/A",
                        // program: e.programName ?? " ",
                        // hours: e.hours != null ? e.hours.toString() : "N/A",
                        // id: e.id!,
                        ),
                  ),
                ],
              );
            }),
            SizedBox(height: 20),
            Obx(() => Center(
                    child: Text(
                  "Total hours attended: ${c.totalHours}\nTotal programs attended: ${c.totalPrograms}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ))),
          ],
        ));
  }

  TableRow _buildDataRow(
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
    return Container(
      color: isHeader ? Colors.teal : null,
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
