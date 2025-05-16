import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nss/controller/attendance_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/attendance/view_attendance_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class ManageAttendanceScreen extends StatelessWidget {
  const ManageAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AttendanceController c = Get.put(AttendanceController());
    TextEditingController searchController = TextEditingController();
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
          if (c.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (c.usersList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/empty_list.json', height: 200),
                  SizedBox(height: 20),
                  Text(
                    'No data available',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

          return RefreshIndicator.adaptive(
            onRefresh: () async => c.onInit(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SearchBar(
                    constraints: BoxConstraints.tight(Size(400, 50)),
                    leading: Icon(Icons.search),
                    controller: searchController,
                    hintText: 'Search',
                    onChanged: (value) => c.onSearchTextChanged(value),
                    trailing: [
                      IconButton(
                          onPressed: () => c.onSearchTextChanged(''),
                          icon: Icon(Icons.cancel))
                    ]),
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
              onSelected: (po) => c.programNameController.text = po,
              selectionList: c.programsList,
              stringValueOf: (item) => item),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                Expanded(
                    child: GetBuilder(
                  id: 'date',
                  builder: (AttendanceController c) =>
                      CustomWidgets().datePickerTextField(
                          padding: const EdgeInsets.only(left: 2, right: 8.0),
                          context: context,
                          controller: c.dateController,
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                          label: "Date",
                          selectedDate: (p0) {
                            c.date = p0;
                            c.update(['date', true]);
                          },
                          initialDate: c.date),
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
