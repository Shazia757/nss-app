import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/controller/program_controller.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/common_pages/loading.dart';
import 'package:nss/view/common_pages/no_data.dart';

class StudentsEnrollmentScreen extends StatelessWidget {
  const StudentsEnrollmentScreen({super.key, this.data});
  final Program? data;

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.find<ProgramListController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(data!.name ?? ''),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton(
              onPressed: () => c.selectAllVolunteers(),
              child: Text("Select all",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer)))
        ],
      ),
      floatingActionButton: Obx(() => c.selectedVolList.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => CustomWidgets().showConfirmationDialog(
                  title: "Submit Attendance",
                  content: SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ListView.builder(
                        itemCount: c.selectedVolList.length,
                        itemBuilder: (context, i) => ListTile(
                              trailing: Text((c.selectedVolList[i].admissionNo)
                                  .toString()),
                              title: Text(c.selectedVolList[i].name ?? ''),
                              subtitle: Text(
                                  c.selectedVolList[i].department?.name ?? ''),
                            )),
                  ),
                  onConfirm: () {
                    c.addAttendance(data);
                  },
                  data: Obx(
                    () => c.isLoading.value
                        ? CircularProgressIndicator()
                        : Text('Confirm'),
                  )),
              child: Icon(Icons.add),
            )
          : SizedBox()),
      body: Obx(
        () => (c.isLoading.value)
            ? LoadingScreen()
            : (c.enrollmentList.isEmpty)
                ? Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        NoDataPage(title: 'No volunteers enrolled'),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 365)),
                                      lastDate: DateTime.now().add(
                                        Duration(days: 365),
                                      )).then(
                                    (value) {
                                      c.programDate = value ?? c.programDate;
                                      c.showProgramDate.value =
                                          DateFormat.yMMMd()
                                              .format(c.programDate);
                                    },
                                  );
                                },
                                iconAlignment: IconAlignment.end,
                                icon: Icon(Icons.edit_calendar),
                                label: Text(c.showProgramDate.value),
                              ),
                              SizedBox(
                                width: 60,
                                height: 50,
                                child: CustomWidgets().textField(
                                    elevation: 1,
                                    controller: c.durationController,
                                    label: "",
                                    keyboardType: TextInputType.number,
                                    suffix: Text("Hrs")),
                              )

                              // TextButton.icon(
                              //   onPressed: () {},
                              //   label: Text(
                              //     "${data!.duration.toString()} hrs",
                              //     style: TextStyle(fontWeight: FontWeight.bold),
                              //   ),
                              //   icon: Icon(Icons.timer_outlined, size: 20),
                              // ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: c.enrollmentList.length,
                            itemBuilder: (context, index) {
                              return Obx(() => CheckboxListTile(
                                    value: c.selectedVolList.any(
                                      (element) =>
                                          element.admissionNo ==
                                          c.enrollmentList[index].volunteer
                                              ?.admissionNo,
                                    ),
                                    onChanged: (value) {
                                      if (value ?? false) {
                                        c.selectedVolList.add(
                                            c.enrollmentList[index].volunteer!);
                                      } else {
                                        c.selectedVolList.removeWhere(
                                          (element) =>
                                              element.admissionNo ==
                                              c.enrollmentList[index].volunteer
                                                  ?.admissionNo,
                                        );
                                      }
                                    },
                                    title: Text(
                                        "${c.enrollmentList[index].volunteer?.name ?? ''} [${c.enrollmentList[index].volunteer?.admissionNo ?? ''}]"),
                                    subtitle: Text(
                                        "${c.enrollmentList[index].volunteer?.department?.category ?? ''} ${c.enrollmentList[index].volunteer?.department?.name ?? ''}"),
                                  ));
                            },
                            separatorBuilder: (context, index) => Divider(),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
