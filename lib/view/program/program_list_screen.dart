import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nss/controller/program_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/program/add_program_screen.dart';
import 'package:nss/view/program/program_details_screen.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.put(ProgramListController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Programs"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Obx(
        () {
          if (c.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (c.programsList.isEmpty) {
            return Center(
              child: Text("No programs found"),
            );
          }
          return RefreshIndicator.adaptive(
              onRefresh: () async => c.onInit(),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    final date = (c.programsList[index].date == null)
                        ? "N/A"
                        : DateFormat.yMMMd()
                            .format(c.programsList[index].date!);
                    return ListTile(
                      onTap: () {
                        Get.to(() => ProgramDetails(
                              data: c.programsList[index],
                            ))?.then((value) => c.onInit());
                      },
                      leading:
                          CircleAvatar(child: Text((index + 1).toString())),
                      title: Text(c.programsList[index].name ?? "N/A"),
                      subtitle: Text(date),
                      trailing: Text(
                          "${c.programsList[index].duration.toString()} Hours"),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: c.programsList.length));
        },
      ),
      floatingActionButton: Visibility(
        visible: LocalStorage().readUser().role != 'vol',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(() => AddProgramScreen(isUpdate: false));
          },
        ),
      ),
    );
  }
}
