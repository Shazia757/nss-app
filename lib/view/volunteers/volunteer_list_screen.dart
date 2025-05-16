import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/empty_list.json', height: 200),
                      SizedBox(height: 20),
                      Text(
                        'No data available',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                    controller: c.searchController,
                    hintText: 'Search',
                    onChanged: (value) => c.onSearchTextChanged(value),
                    trailing: [
                      IconButton(
                          onPressed: () {
                           
                            c.onSearchTextChanged('');
                          },
                          icon: Icon(Icons.cancel))
                    ]),
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
