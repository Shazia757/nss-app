import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/view/volunteers/profile_screen.dart';

import '../../controller/volunteer_controller.dart';

class VolunteersListScreen extends StatelessWidget {
  const VolunteersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    VolunteerListController c = Get.put(VolunteerListController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => VolunteerAddScreen(isUpdateScreen: false))
              ?.then((value) => c.getData());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          title: Text("Volunteers List"),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
          actions: [
            IconButton(onPressed: () => c.getData(), icon: Icon(Icons.refresh))
          ]),
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
              child: Text("No volunteers found"),
            );
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async => c.getData(),
            child: ListView.separated(
              itemCount: c.usersList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text((c.usersList[index].admissionNo).toString()),
                  title: Text(c.usersList[index].name ?? ''),
                  subtitle: Text(c.usersList[index].department ?? ''),
                  trailing: IconButton(
                      onPressed: () {
                        c.updateVolunteer(
                            (c.usersList[index].admissionNo).toString());
                      },
                      icon: Icon(
                        Icons.edit_note_outlined,
                      )),
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          );
        },
      )),
    );
  }
}
