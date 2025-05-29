import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
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
              ?.then((value) => c.onInit());
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
                  controller: c.searchController,
                  hintText: 'Search Volunteer',
                  onChanged: (value) => c.onSearchTextChanged(value),
                  visible: c.searchController.text.isNotEmpty,
                  onPressedCancel: () => c.onSearchTextChanged(''),
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: c.searchList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading:
                            Text((c.searchList[index].admissionNo).toString()),
                        title: Text(c.searchList[index].name ?? ''),
                        subtitle: Text(c.searchList[index].department ?? ''),
                        trailing: IconButton(
                            onPressed: () {
                              c.updateVolunteer(
                                  (c.searchList[index].admissionNo).toString());
                            },
                            icon: Icon(
                              Icons.edit_note_outlined,
                            )),
                      );
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
}
