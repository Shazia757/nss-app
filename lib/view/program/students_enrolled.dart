import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/controller/program_controller.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/view/common_pages/loading.dart';
import 'package:nss/view/common_pages/no_data.dart';

class StudentsEnrolled extends StatelessWidget {
  const StudentsEnrolled({super.key, this.data});
  final Program? data;

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.put(ProgramListController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Students Enrolled"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Obx(
        () => (c.isLoading.value)
            ? LoadingScreen()
            : (c.enrollmentList.isEmpty)
                ? Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        NoDataPage(title: 'No students enrolled'),
                      ],
                    ),
                  )
                : Card.outlined(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Date: ${DateFormat.yMMMd().format(DateTime.parse(data!.date.toString()))}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("Hours: ${data!.duration.toString()}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Text(
                            data!.name ?? "",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: c.enrollmentList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  minTileHeight: 65,
                                  leading: SizedBox(
                                    width: 40,
                                    height: 60,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        c.enrollmentList[index].volunteer
                                                ?.admissionNo ??
                                            '',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      c.enrollmentList[index].volunteer?.name ??
                                          ''),
                                  subtitle: Text(
                                      "${c.enrollmentList[index].volunteer?.department?.category ?? ''} ${c.enrollmentList[index].volunteer?.department?.name ?? ''}"),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
