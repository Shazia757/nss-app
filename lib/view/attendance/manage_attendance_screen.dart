import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nss/controller/attendance_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/attendance/view_attendance_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class ManageAttendanceScreen extends StatelessWidget {
  const ManageAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());
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
          IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))
        ],
      ),
      body: SafeArea(child: Obx(
        () {
          if (c.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (c.usersList.isEmpty) {
           return CustomWidgets.noDataWidget;
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async => c.onInit(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CustomWidgets().searchBar(
                  constraints: BoxConstraints.tight(Size(350, 50)),
                  leading: Icon(Icons.search),
                  controller: c.searchController,
                  hintText: 'Search',
                  onChanged: (value) => c.onSearchTextChanged(value),
                  visible: c.searchController.text.isNotEmpty,
                  onPressedCancel: () => c.onSearchTextChanged(''),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: c.searchList.length,
                    itemBuilder: (context, index) {
                      return Obx(() => CheckboxListTile(
                            value: c.selectedVolList.any(
                              (element) =>
                                  element.admissionNo ==
                                  c.searchList[index].admissionNo,
                            ),
                            secondary: InkWell(
                              onTap: () => Get.to(() => ViewAttendanceScreen(
                                  id: LocalStorage().readUser().admissionNo!)),
                              child: CircleAvatar(
                                radius: 40,
                                child:
                                    Text(c.searchList[index].admissionNo ?? ''),
                              ),
                            ),
                            title: Text(c.searchList[index].name ?? ''),
                            subtitle:
                                Text(c.searchList[index].department ?? ''),
                            onChanged: (value) {
                              if (value == true) {
                                c.selectedVolList.add(c.searchList[index]);
                              } else {
                                c.selectedVolList.removeWhere((element) =>
                                    element.admissionNo ==
                                    c.searchList[index].admissionNo);
                              }
                            },
                          ));
                    },
                    separatorBuilder: (context, index) => Divider(),
                  ),
                ),
              ],
            ),
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
              onSelected: (po) {
                c.programNameController.text = po;
                c.programName = po;
              },
              selectionList: c.programsList,
              stringValueOf: (item) => item),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: GetBuilder(
                  id: 'date',
                  builder: (AttendanceController c) => Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: CustomWidgets().datePickerTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        context: context,
                        controller: c.dateController,
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                        label: "Date",
                        selectedDate: (p0) {
                          c.date = p0;
                          c.update(['date', true]);
                        },
                        initialDate: c.date,
                        decoration: InputDecoration(
                          label: Text("Date"),
                          border: InputBorder.none,
                        )),
                  ),
                )),
                Expanded(
                  child: CustomWidgets().textField(
                    controller: c.durationController,
                    label: 'Duration',
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
                    // showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //         actions: [
                    //           TextButton(
                    //               onPressed: () => Get.back(),
                    //               child: Text("Cancel")),
                    //           TextButton(
                    //             onPressed: () {
                    //               c.onSubmitAttendance();
                    //               Get.back();
                    //             },
                    //             child: Text("Confirm",
                    //                 style: TextStyle(color: Colors.red)),
                    //           ),
                    //         ],
                    //         shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12)),
                    //         title: Text(
                    //             'Are you sure you want to add attendance for the following volunteers?'),
                    //         content: Expanded(
                    //           child: ListView.separated(
                    //             shrinkWrap: true,
                    //             itemCount: c.selectedVolList.length,
                    //             itemBuilder: (context, index) {
                    //               return ListTile(
                    //                 leading: Text(
                    //                     (c.selectedVolList[index].admissionNo)
                    //                         .toString()),
                    //                 title: Text(
                    //                     c.selectedVolList[index].name ?? ''),
                    //                 subtitle: Text(
                    //                     c.selectedVolList[index].department ??
                    //                         ''),
                    //               );
                    //             },
                    //             separatorBuilder: (context, index) =>
                    //                 Divider(),
                    //           ),
                    //         ));
                    //   },
                    // );
                    if (c.onSubmitAttendanceValidation()) {
                      CustomWidgets().showConfirmationDialog(
                          title: "Submit Attendance",
                          content: SizedBox(
                            height: 200,
                            width: double.maxFinite,
                            child: ListView.builder(
                                itemCount: c.selectedVolList.length,
                                itemBuilder: (context, i) => ListTile(
                                      trailing: Text(
                                          (c.selectedVolList[i].admissionNo)
                                              .toString()),
                                      title:
                                          Text(c.selectedVolList[i].name ?? ''),
                                      subtitle: Text(
                                          c.selectedVolList[i].department ??
                                              ''),
                                    )),
                          ),
                          onConfirm: () {
                            c.onSubmitAttendance();
                          });
                    }
                  },
                  child: Text("Submit"),
                )),
        ],
      ),
    );
  }
}
