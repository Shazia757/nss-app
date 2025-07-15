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
        title: Text("Issues", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))],
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
                unselectedLabelColor: Theme.of(context).colorScheme.onPrimaryContainer,
                onTap: (value) => c.isResolved.value = (value == 1),
                tabs: [
                  Tab(text: "Opened"),
                  Tab(text: "Resolved"),
                ],
              ),
              Expanded(
                child: TabBarView(controller: c.adminTabController, children: [
                  Obx(() {
                    return Column(
                      children: [
                        filterAndSort(),
                        (c.isLoading.value)
                            ? LoadingScreen()
                            : (c.modifiedOpenedList.isEmpty)
                                ? NoDataPage(title: 'No issues reported')
                                : Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(10),
                                        itemBuilder: (context, index) {
                                          return issueListTile(
                                            count: index + 1,
                                            data: c.modifiedOpenedList[index],
                                            isOpen: true,
                                          );
                                        },
                                        itemCount: c.modifiedOpenedList.length),
                                  ),
                      ],
                    );
                  }),
                  // ---------------------- 2nd view ----------------------
                  Obx(() {
                    return Column(
                      children: [
                        filterAndSort(),
                        (c.isLoading.value)
                            ? LoadingScreen()
                            : (c.modifiedClosedList.isEmpty)
                                ? NoDataPage(title: 'No issues resolved')
                                : Expanded(
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
              MenuItemButton(child: Text("Secretary"), onPressed: () => c.filterByRole('sec')),
              Visibility(
                visible: LocalStorage().readUser().role != 'sec',
                child: MenuItemButton(child: Text("Program Officer"), onPressed: () => c.filterByRole('po')),
              ),
              Visibility(
                visible: LocalStorage().readUser().role != 'sec',
                child: MenuItemButton(child: Text("All"), onPressed: () => c.filterByRole('all')),
              ),
            ], label: "\tAssigned to", icon: Icons.filter_alt_rounded),
            SizedBox(
              height: 38,
              width: 2,
              child: VerticalDivider(indent: 5, endIndent: 2),
            ),
            CustomWidgets().menuBuilder(menuChildren: [
              MenuItemButton(child: Text("Oldest"), onPressed: () => c.sortByOldestDate(true)),
              MenuItemButton(child: Text("Latest"), onPressed: () => c.sortByOldestDate(false)),
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
                        (e) => MenuItemButton(child: Text(e?.name ?? "N/A"), onPressed: () => c.resolvedBy(e?.admissionNo)),
                      )
                      .toList(),
                  label: "  Resolved By",
                  icon: Icons.task_alt_outlined),
            ),
          ],
        ),
        Divider(),
        SizedBox(height: 5)
      ],
    );
  }

  Card issueListTile({required Issues data, required bool isOpen, required int count}) {
    final to = (data.to == 'po') ? 'Program Officer' : 'Secretary';
    RxBool isDataLoading = false.obs;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(vertical: 12),
        shadowColor: isOpen ? const Color.fromARGB(98, 159, 16, 6) : const Color.fromARGB(71, 76, 175, 79),
        child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: Obx(() => isDataLoading.isTrue
                ? CircularProgressIndicator()
                : CircleAvatar(
                    radius: 24,
                    backgroundColor: isOpen ? const Color.fromARGB(255, 159, 16, 6) : Colors.green,
                    child: Text(
                      "$count",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )),
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
              final dept = "${data.createdBy?.department?.category ?? ''} ${data.createdBy?.department?.name ?? ""}";
              dialog(data, isOpen, dept);
            }));
  }

  Future<dynamic> dialog(Issues data, bool isOpen, String dept) {
    final resolvedBy = c.adminList.firstWhereOrNull((e) => e?.admissionNo == data.updatedBy);
    return showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        title: Text(
          data.subject ?? "N/A",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow("Status:", isOpen ? "Open" : "Resolved"),
              _infoRow(
                  isOpen ? "Reported on:" : "Resolved on:",
                  DateFormat.yMMMd().format(
                    isOpen ? (data.createdDate ?? DateTime.now()) : (data.updatedDate ?? DateTime.now()),
                  )),
              _infoRow("Reported by:", (data.createdBy?.name ?? "N/A")),
              _infoRow("Admission no:", data.createdBy?.admissionNo ?? "N/A"),
              _infoRow("Department:", dept),
              const SizedBox(height: 20),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(data.description ?? "N/A"),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (isOpen)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff5f5791),
              ),
              onPressed: () => CustomWidgets().showConfirmationDialog(
                title: "Resolve Issue",
                content: const Text("Are you sure you have resolved the issue?"),
                onConfirm: () => c.resolveIssue(data.id),
                data: Obx(() => c.isLoading.value ? const CircularProgressIndicator() : const Text("Confirm", style: TextStyle(color: Colors.red))),
              ),
              child: const Text("Resolve", style: TextStyle(color: Colors.white)),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel", style: TextStyle(color: Color(0xff5f5791))),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
