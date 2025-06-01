import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/common_pages/loading.dart';
import 'package:nss/view/common_pages/no_data.dart';

import '../../controller/issues_controller.dart';
import '../../model/issues_model.dart';

class ScreenAdminIssues extends StatelessWidget {
  ScreenAdminIssues({super.key});
  final IssuesController c = Get.put(IssuesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issues",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))
        ],
      ),
      bottomNavigationBar: CustomNavBar(currentIndex: 1),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                controller: c.adminTabController,
                labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                onTap: (value) => c.isResolved.value = (value == 1),
                tabs: [
                  Tab(text: "Opened"),
                  Tab(text: "Resolved"),
                ],
              ),
              Expanded(
                child: TabBarView(controller: c.adminTabController, children: [
                  Obx(() {
                    if (c.isLoading.value) {
                      return Expanded(child: LoadingScreen());
                    } else if (c.modifiedOpenedList.isEmpty) {
                      return Expanded(child: NoDataPage());
                    }
                    return Column(
                      children: [
                        Obx(() => filterAndSort()),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return issueListTile(
                                count: index + 1,
                                data: c.modifiedOpenedList[index],
                                isOpen: true,
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemCount: c.modifiedOpenedList.length,
                          ),
                        ),
                      ],
                    );
                  }),
                  // ---------------------- 2nd view ----------------------
                  Obx(() {
                    if (c.isLoading.value) {
                      return Expanded(child: LoadingScreen());
                    } else if (c.modifiedClosedList.isEmpty) {
                      return Expanded(child: NoDataPage());
                    }
                    return Column(
                      children: [
                        Obx(() => filterAndSort()),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return issueListTile(
                                count: index + 1,
                                data: c.modifiedClosedList[index],
                                isOpen: false,
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemCount: c.modifiedClosedList.length,
                          ),
                        ),
                      ],
                    );
                  })
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column filterAndSort() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomWidgets().menuBuilder(menuChildren: [
              MenuItemButton(
                  child: Text("Secretary"),
                  onPressed: () => c.filterByRole('sec')),
              Visibility(
                visible: LocalStorage().readUser().role != 'sec',
                child: MenuItemButton(
                    child: Text("Program Officer"),
                    onPressed: () => c.filterByRole('po')),
              ),
              Visibility(
                visible: LocalStorage().readUser().role != 'sec',
                child: MenuItemButton(
                    child: Text("All"), onPressed: () => c.filterByRole('all')),
              ),
            ], label: "\tAssigned to", icon: Icons.filter_alt_rounded),
            SizedBox(
              height: 38,
              width: 2,
              child: VerticalDivider(indent: 5, endIndent: 2),
            ),
            CustomWidgets().menuBuilder(menuChildren: [
              MenuItemButton(
                  child: Text("Oldest"),
                  onPressed: () => c.sortByOldestDate(true)),
              MenuItemButton(
                  child: Text("Latest"),
                  onPressed: () => c.sortByOldestDate(false)),
            ], label: "\t\tSort by date", icon: Icons.sort),
            Visibility(
              visible: c.isResolved.isTrue,
              child: SizedBox(
                height: 38,
                width: 2,
                child: VerticalDivider(indent: 5, endIndent: 2),
              ),
            ),
            Visibility(
              visible: c.isResolved.isTrue,
              child: CustomWidgets().menuBuilder(
                  menuChildren: c.adminList
                      .map(
                        (e) => MenuItemButton(
                            child: Text(e?.name ?? "N/A"),
                            onPressed: () => c.resolvedBy(e?.admissionNo)),
                      )
                      .toList(),
                  label: "\t\tResolved by ",
                  icon: Icons.task_alt_outlined),
            ),
          ],
        ),
        Divider(),
        SizedBox(height: 5)
      ],
    );
  }

  Card issueListTile(
      {required Issues data, required bool isOpen, required int count}) {
    final to = (data.to == 'po') ? 'Program Officer' : 'Secretary';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      shadowColor: isOpen
          ? const Color.fromARGB(98, 159, 16, 6)
          : const Color.fromARGB(71, 76, 175, 79),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              isOpen ? const Color.fromARGB(255, 159, 16, 6) : Colors.green,
          child: Text(
            "$count",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          data.subject ?? "N/A",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Text("To: $to", style: TextStyle(color: Colors.grey[700])),
        ),
        trailing: Text(
          DateFormat.yMMMd().format(data.createdDate ?? DateTime.now()),
        ),
        onTap: () {
          c.getUserDetails(data.createdBy);
          Get.defaultDialog(
            title: data.subject ?? "N/A",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isOpen ? 'Reported on:' : 'Resolved on:'),
                        Text('Reported by:'),
                        Text('Admission number: '),
                        Text('Department:'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isOpen
                            ? DateFormat.yMMMd()
                                .format(data.createdDate ?? DateTime.now())
                            : DateFormat.yMMMd()
                                .format(data.updatedDate ?? DateTime.now())),
                        Text('${c.usersName}'),
                        Text('${data.createdBy}'),
                        Text('${c.department}')
                      ],
                    ),
                  ],
                ),
                Text(data.description ?? "N/A"),
              ],
            ),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            actions: [
              isOpen
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff5f5791)),
                      onPressed: () {
                        c.resolveIssue(data.id);
                        Get.back();
                      },
                      child: Text("Resolve",
                          style: TextStyle(color: Colors.white)),
                    )
                  : SizedBox(),
              TextButton(
                onPressed: () => Get.back(),
                child:
                    Text("Cancel", style: TextStyle(color: Color(0xff5f5791))),
              ),
            ],
          );
        },
      ),
    );
  }
}
