import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/common_pages/no_data.dart';

import '../../controller/issues_controller.dart';
import '../../model/issues_model.dart';
import 'admin_issues_screen.dart';

class ScreenIssues extends StatelessWidget {
  const ScreenIssues({super.key});

  @override
  Widget build(BuildContext context) {
    if (LocalStorage().readUser().role != "vol") {
      return ScreenAdminIssues();
    } else {
      return ScreenUserIssues();
    }
  }
}

class ScreenUserIssues extends StatelessWidget {
  final IssuesController c = Get.put(IssuesController());

  ScreenUserIssues({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Issues"),
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.primaryContainer,
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 50),
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: c.tabController,
                tabs: [
                  Tab(child: Text("Report an issue")),
                  Tab(child: Text("Issues Reported")),
                ],
              ),
            ),
          ),
          actions: [IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))],
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
        body: TabBarView(
          controller: c.tabController,
          children: [
            reportIssueView(context),
            reportedIssueView(Theme.of(context)),
          ],
        ),
      ),
    );
  }

  Widget reportedIssueView(ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: 12),
        TabBar.secondary(
          dividerColor: Colors.transparent,
          padding: EdgeInsets.all(10),
          indicator: BoxDecoration(
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: theme.colorScheme.surfaceDim,
          ),
          tabs: [Tab(text: "Opened"), Tab(text: "Closed")],
          onTap: (i) {
            c.isResolved.value = (i == 1);
            c.getVolIssues();
          },
        ),
        Obx(() => filterAndSort()),
        Expanded(
          child: Obx(() {
            return TabBarView(children: [
              RefreshIndicator.adaptive(
                  onRefresh: () async => c.getVolIssues(),
                  child: c.isLoading.isTrue
                      ? Center(child: CircularProgressIndicator())
                      : c.modifiedOpenedList.isEmpty
                          ? NoDataPage(title: 'No issues reported')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => issueListTile(data: c.modifiedOpenedList[index], isOpen: true, count: index + 1),
                              itemCount: c.modifiedOpenedList.length,
                            )),
              RefreshIndicator.adaptive(
                  onRefresh: () async => c.getVolIssues(),
                  child: Center(
                    child: c.isLoading.isTrue
                        ? CircularProgressIndicator()
                        : c.modifiedClosedList.isEmpty
                            ? NoDataPage(
                                title: 'No resolved issues',
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  return issueListTile(data: c.modifiedClosedList[index], isOpen: false, count: index + 1);
                                },
                                itemCount: c.modifiedClosedList.length,
                              ),
                  )),
            ]);
          }),
        )
      ],
    );
  }

  Widget reportIssueView(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => InkWell(
                      onTap: () => c.submittedTo.value = 'sec',
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: (c.submittedTo.value == 'sec') ? (Theme.of(context).colorScheme.primaryContainer) : null,
                          border: Border.all(color: (c.submittedTo.value == 'sec') ? (Theme.of(context).colorScheme.primary) : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('To Secretary'),
                      ),
                    )),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Obx(() => InkWell(
                      onTap: () => c.submittedTo.value = 'po',
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: (c.submittedTo.value == 'po') ? (Theme.of(context).colorScheme.primaryContainer) : null,
                          border: Border.all(color: (c.submittedTo.value == 'po') ? (Theme.of(context).colorScheme.primary) : Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('To Program Officer'),
                      ),
                    )),
              ),
            ],
          ),
        ),
        CustomWidgets().textField(controller: c.subjectController, label: "Subject", margin: EdgeInsets.symmetric(vertical: 15)),
        CustomWidgets().textField(controller: c.desController, maxlines: 8, label: "Description", margin: EdgeInsets.only(bottom: 20)),
        CustomWidgets().buildActionButton(
          context: context,
          onPressed: () {
            if (c.onSubmitIssueValidation()) {
              CustomWidgets().showConfirmationDialog(
                  title: "Report Issue",
                  message: "Are you sure you want to report the issue?",
                  onConfirm: () => c.reportIssue(),
                  data: Obx(
                    () => (c.isReportLoading.value) ? CircularProgressIndicator() : Text("Confirm", style: TextStyle(color: Colors.red)),
                  ));
            }
          },
          text: "Report",
          color: Theme.of(context).colorScheme.error,
        ),
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
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isOpen ? DateFormat.yMMMd().format(data.createdDate ?? DateTime.now()) : DateFormat.yMMMd().format(data.updatedDate ?? DateTime.now())),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(data.description ?? "N/A"),
              ],
            ),
            backgroundColor: Colors.white,
            titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("Cancel", style: TextStyle(color: Color(0xff5f5791))),
              ),
            ],
          );
        },
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
                      (e) => MenuItemButton(
                        child: Text(
                          e?.name ?? "N/A",
                          style: (c.resolvedByAdmID.value == e?.admissionNo)
                              ? TextStyle(
                                  color: Theme.of(Get.context!).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                )
                              : null,
                        ),
                        onPressed: () => c.resolvedBy(e?.admissionNo),
                      ),
                    )
                    .toList(),
                label: "  Resolved By",
                icon: Icons.task_alt_outlined,
              ),
            ),
          ],
        ),
        Divider(),
        SizedBox(height: 5)
      ],
    );
  }
}
