import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

import '../../controller/issues_controller.dart';
import '../../model/issues_model.dart';

enum To { sec, po, secAndpo }

class ScreenAdminIssues extends StatelessWidget {
  ScreenAdminIssues({super.key});
  final IssuesController c = Get.put(IssuesController());
  final date = Rx<Date>(Date.oldestToLatest);
  final Map<String, String> roleLabels = {
    'sec': 'Secretary',
    'po': 'Program Officer',
    'both': 'Secretary and Program Officer',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Issues",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () => c.getAdminIssues(), icon: Icon(Icons.refresh))
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
                labelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onPrimaryContainer,
                tabs: [
                  Tab(text: "Opened"),
                  Tab(text: "Resolved"),
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (LocalStorage().readUser().role == 'po')
                                ? TextButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        constraints:
                                            BoxConstraints.tight(Size.infinite),
                                        useSafeArea: true,
                                        showDragHandle: true,
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            children: [
                                              Text('Reported To'),
                                              SizedBox(height: 5),
                                              Obx(
                                                () => Wrap(
                                                  spacing: 8,
                                                  children: roleLabels.entries
                                                      .map((e) {
                                                    return ChoiceChip(
                                                      label: Text(e.value),
                                                      selected:
                                                          c.selected.value ==
                                                              e.key,
                                                      onSelected: (value) =>
                                                          c.selected(e.key),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    label: Text('Filter'),
                                    icon: Icon(Icons.filter_alt),
                                  )
                                : SizedBox(),
                            TextButton.icon(
                              label: Text('Sort'),
                              onPressed: () =>
                                  sortBottomSheet(context, c, (Date? value) {
                                if (value != null) {
                                  date.value = value;
                                  c.sortOpenedList(value);
                                }
                              }),
                              icon: Icon(Icons.sort),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          if (c.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          } else if (c.openFilteredTo.isEmpty) {
                            return Center(child: Text("No issues reported"));
                          }
                          return ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return issueListTile(
                                count: index + 1,
                                data: c.openFilteredTo[index],
                                isOpen: true,
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemCount: c.openFilteredTo.length,
                          );
                        }),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 400,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (LocalStorage().readUser().role == 'po')
                                ? TextButton.icon(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        constraints:
                                            BoxConstraints.tight(Size.infinite),
                                        useSafeArea: true,
                                        showDragHandle: true,
                                        context: context,
                                        builder: (context) {
                                          return Column(
                                            children: [
                                              Text('Reported To'),
                                              SizedBox(height: 5),
                                              Obx(
                                                () => Wrap(
                                                  spacing: 8,
                                                  children: roleLabels.entries
                                                      .map((e) {
                                                    return ChoiceChip(
                                                      label: Text(e.value),
                                                      selected:
                                                          c.selected.value ==
                                                              e.key,
                                                      onSelected: (value) =>
                                                          c.selected(e.key),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text('Resolved By'),
                                              SizedBox(height: 5),
                                              Obx(() => Wrap(
                                                    spacing: 8,
                                                    children:
                                                        c.resolvedBy.map((e) {
                                                      return ChoiceChip(
                                                        label: Text(e),
                                                        selected:
                                                            c.selected.value ==
                                                                e,
                                                        onSelected: (value) =>
                                                            c.selected(e),
                                                      );
                                                    }).toList(),
                                                  )),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    label: Text('Filter'),
                                    icon: Icon(Icons.filter_alt),
                                  )
                                : SizedBox(),
                            TextButton.icon(
                              label: Text('Sort'),
                              onPressed: () =>
                                  sortBottomSheet(context, c, (Date? value) {
                                if (value != null) {
                                  date.value = value;
                                  c.sortClosedList(value);
                                }
                              }),
                              icon: Icon(Icons.sort),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          if (c.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          } else if (c.closedList.isEmpty) {
                            return Center(child: Text("No issues reported"));
                          }
                          return ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return issueListTile(
                                count: index + 1,
                                data: c.closedList[index],
                                isOpen: false,
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemCount: c.closedList.length,
                          );
                        }),
                      ),
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      ),
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
          Get.defaultDialog(
            title: data.subject ?? "N/A",
            middleText: data.description ?? "N/A",
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

  sortBottomSheet(BuildContext context, IssuesController c,
      void Function(Date?)? onChanged) {
    return showModalBottomSheet(
      constraints: BoxConstraints.tight(Size.infinite),
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Expanded(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'SORT BY',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(),
              Obx(
                () => ListTile(
                  title: Text('Date-Oldest to Latest'),
                  trailing: Radio<Date>(
                      value: Date.oldestToLatest,
                      groupValue: date.value,
                      onChanged: onChanged),
                ),
              ),
              Obx(
                () => ListTile(
                  title: Text('Date-Latest to Oldest '),
                  trailing: Radio<Date>(
                      value: Date.latestToOldest,
                      groupValue: date.value,
                      onChanged: onChanged),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
