import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/controller/attendance_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/view/attendance/view_attendance_screen.dart';
import 'package:nss/view/custom_decorations.dart';

class ManageAttendanceScreen extends StatelessWidget {
  const ManageAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());
    c.getUsers();
    c.getPrograms();

    return Scaffold(
      floatingActionButton: Obx(() => !c.isProgramLoading.isTrue
          ? c.selectedVolList.isNotEmpty
              ? FloatingActionButton(
                  onPressed: () => addAttendanceBottomSheet(context, c),
                  child: Icon(Icons.add),
                )
              : SizedBox()
          : SizedBox()),
      appBar: AppBar(
        title: Text("Manage Attendance"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
              onPressed: () => c.attendanceList(), icon: Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(child: Obx(
        () {
          if (c.usersList.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: c.usersList.length,
            itemBuilder: (context, index) {
              return Obx(() => CheckboxListTile(
                    value: c.selectedVolList.any(
                      (element) =>
                          element.admissionNo == c.usersList[index].admissionNo,
                    ),
                    secondary: InkWell(
                      onTap: () => Get.to(() => ViewAttendanceScreen(
                          id: LocalStorage().readUser().admissionNo!)),
                      child: CircleAvatar(
                        radius: 40,
                        child: Text(c.usersList[index].admissionNo ?? ''),
                      ),
                    ),
                    title: Text(c.usersList[index].name ?? ''),
                    subtitle: Text(c.usersList[index].department ?? ''),
                    onChanged: (value) {
                      if (value == true) {
                        c.selectedVolList.add(c.usersList[index]);
                      } else {
                        c.selectedVolList.removeWhere((element) =>
                            element.admissionNo ==
                            c.usersList[index].admissionNo);
                      }
                    },
                  ));
            },
            separatorBuilder: (context, index) => Divider(),
          );
        },
      )),
    );
  }

  addAttendanceBottomSheet(BuildContext context, AttendanceController c) {
    return showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      builder: (context) => ListView(
        padding: EdgeInsets.all(10),
        children: [
          CustomWidgets.searchableDropDown(
              controller: c.programNameController,
              label: "Program Name",
              onSelected: (po) => c.programNameController.text = po,
              selectionList: c.programsList,
              stringValueOf: (item) => item),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 8.0),
                    child: TextField(
                      readOnly: true,
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                            initialDate: c.selectedDate,
                            context: context,
                            firstDate: DateTime(2023),
                            lastDate: DateTime.now());
                        c.dateController.text = (selectedDate != null)
                            ? DateFormat.yMMMd().format(selectedDate)
                            : "";
                        c.date = selectedDate;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Date"),
                      controller: c.dateController,
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: c.durationController,
                    decoration: CustomWidgets.textFieldDecoration(
                      label: 'Duration',
                      prefix: Icon(Icons.event),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => c.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : FilledButton(
                  onPressed: () {
                    if (c.onSubmitAttendanceValidation()) {
                      CustomWidgets().showConfirmationDialog(
                          title: "Submit Attendance",
                          message:
                              "Are you sure you want to submit the attendance?",
                          onConfirm: () {
                            c.onSubmitAttendance();
                          });
                    }
                  },
                  child: Text("Submit"),
                )),
          SizedBox(width: 10),
          Obx(() => Text("Selected volunteers (${c.selectedVolList.length}):",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: c.selectedVolList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(c.selectedVolList[index].admissionNo ?? 'N/A'),
                        SizedBox(width: 25),
                        Text(c.selectedVolList[index].name ?? 'N/A'),
                      ],
                    ),
                    Text(c.selectedVolList[index].department ?? 'N/A'),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          )
        ],
      ),
    );
  }
}
