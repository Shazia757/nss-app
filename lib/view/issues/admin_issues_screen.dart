import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/view/custom_decorations.dart';

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
                  Obx(() {
                    if (c.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    } else if (c.openedList.isEmpty) {
                      return Center(
                        child: Text("No issues reported"),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        return issueListTile(
                          count: index + 1,
                          data: c.openedList[index],
                          isOpen: true,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemCount: c.openedList.length,
                    );
                  }),
                  Obx(() {
                    if (c.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    } else if (c.closedList.isEmpty) {
                      return Center(
                        child: Text("No resolved issues"),
                      );
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
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemCount: c.closedList.length,
                    );
                  }),
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
}
