import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nss/controller/attendance_controller.dart';
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
      floatingActionButton: Obx(
        () => c.isProgramLoading.isTrue
            ? SizedBox()
            : FloatingActionButton(
                onPressed: () => addAttendanceBottomSheet(context, c),
                child: Icon(Icons.add),
              ),
      ),
      appBar: AppBar(
        title: Text("Manage Attendance"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
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
            itemBuilder: (context, index) => Obx(() => CheckboxListTile(
                  value: c.selectedVolList
                      .contains(c.usersList[index].admissionNo),
                  secondary: InkWell(
                    onTap: () => Get.to(() => ViewAttendanceScreen(
                        id: c.usersList[index].admissionNo ?? "")),
                    child: CircleAvatar(
                      radius: 40,
                      child: Text(c.usersList[index].admissionNo ?? ''),
                    ),
                  ),
                  title: Text(c.usersList[index].name ?? ''),
                  subtitle: Text(c.usersList[index].department ?? ''),
                  onChanged: (value) {
                    if (value == true) {
                      c.selectedVolList.add(c.usersList[index].admissionNo!);
                    } else {
                      c.selectedVolList.remove(c.usersList[index].admissionNo);
                    }
                  },
                )),
            separatorBuilder: (context, index) => Divider(),
          );
        },
      )),
    );
  }

  addAttendanceBottomSheet(BuildContext context, AttendanceController c) {
    return showModalBottomSheet(
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
                  child: CustomWidgets().datePickerTextField(
                    context: context,
                    label: 'Date',
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    controller: c.dateController,
                    selectedDate: (date) => c.selectedDate = date,
                    padding: EdgeInsets.only(right: 15),
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
          FilledButton(
              onPressed: () {
                !c.onSubmitAttendanceValidation()
                    ? () {}
                    : showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure?'),
                          content:
                              Text('Do you want to submit the attendance?'),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Success'),
                                      content: Text(
                                          'Attendance has been successfully submitted.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => c.onSubmitAttendance(
                                              Attendance().admissionNo !),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text('Submit')),
                          ],
                        ),
                      );
              },
              child: Text('Submit')),
        ],
      ),
    );
  }
}
