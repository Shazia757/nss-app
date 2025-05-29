import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

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
          actions: [
            IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))
          ],
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
                          ? CustomWidgets.noDataWidget
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => listTileView(
                                  c.modifiedOpenedList[index],
                                  count: "${index + 1}"),
                              itemCount: c.modifiedOpenedList.length,
                            )),
              RefreshIndicator.adaptive(
                  onRefresh: () async => c.getVolIssues(),
                  child: Center(
                    child: c.isLoading.isTrue
                        ? CircularProgressIndicator()
                        : c.modifiedClosedList.isEmpty
                            ? Text('No resolved issues.')
                            : ListView.builder(
                                padding: EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  return listTileView(
                                      c.modifiedClosedList[index],
                                      count: "${index + 1}");
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
        // Text('  Report To:', style: Theme.of(context).textTheme.labelLarge),
        Row(
          children: [
            Expanded(
              child: Obx(() => InkWell(
                    onTap: () {
                      c.submittedTo.value = 'sec';
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: (c.submittedTo.value == 'sec')
                            ? (Theme.of(context).colorScheme.primaryContainer)
                            : null,
                        border: Border.all(
                            color: (c.submittedTo.value == 'sec')
                                ? (Theme.of(context).colorScheme.primary)
                                : Colors.grey.shade400),
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
                    onTap: () {
                      c.submittedTo.value = 'po';
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: (c.submittedTo.value == 'po')
                            ? (Theme.of(context).colorScheme.primaryContainer)
                            : null,
                        border: Border.all(
                            color: (c.submittedTo.value == 'po')
                                ? (Theme.of(context).colorScheme.primary)
                                : Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text('To Program Officer'),
                    ),
                  )),
            ),
          ],
        ),
        CustomWidgets().textField(
            controller: c.subjectController,
            label: "Subject",
            margin: EdgeInsets.symmetric(vertical: 10)),
        CustomWidgets().textField(
          controller: c.desController,
          maxlines: 12,
          label: "Description",
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => c.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : FilledButton(
                    onPressed: () {
                      if (c.onSubmitIssueValidation()) {
                        CustomWidgets().showConfirmationDialog(
                            title: "Report Issue",
                            message:
                                "Are you sure you want to report the issue?",
                            onConfirm: () {
                              c.reportIssue();
                            });
                      }
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.red[900]),
                    child: Text("Report"),
                  ))),
      ],
    );
  }

  Widget listTileView(Issues data, {required String count}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          data.subject ?? "N/A",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              "To: ${data.to}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
        leading: CircleAvatar(
          radius: 20,
          child: Text(
            count,
          ),
        ),
        trailing: data.createdDate != null
            ? Text(
                DateFormat.yMMMd().format(data.createdDate!),
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              )
            : Text(''),
        onTap: () {
          Get.defaultDialog(
            title: data.subject ?? "N/A",
            middleText: data.description ?? "N/A",
            barrierDismissible: true,
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text("Close"),
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
}
