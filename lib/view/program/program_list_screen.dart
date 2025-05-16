import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nss/controller/program_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/program/add_program_screen.dart';
import 'package:nss/view/program/program_details_screen.dart';

enum Date { oldestToLatest, latestToOldest }

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.put(ProgramListController());
    Date? date;

    return Scaffold(
      appBar: AppBar(
        title: Text("Programs"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh))
        ],
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
            return CustomWidgets.noDataWidget;
          }
          return RefreshIndicator.adaptive(
              onRefresh: () async => c.onInit(),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SearchBar(
                              constraints: BoxConstraints.tight(Size(100, 50)),
                              leading: Icon(Icons.search),
                              controller: c.searchController,
                              hintText: 'Search',
                              onChanged: (value) =>
                                  c.onSearchTextChanged(value),
                              trailing: [
                                IconButton(
                                    onPressed: () => c.onSearchTextChanged(''),
                                    icon: Icon(Icons.cancel))
                              ]),
                        ),
                        PopupMenuButton(
                          tooltip: "Sort by",
                          initialValue: date,
                          onSelected: (value) => date = value,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: Date.oldestToLatest,
                              child: Text("Oldest"),
                              onTap: () => c.sortByDate(Date.oldestToLatest),
                            ),
                            PopupMenuItem(
                              value: Date.latestToOldest,
                              child: Text("Latest"),
                              onTap: () => c.sortByDate(Date.latestToOldest),
                            )
                          ],
                          child: Text('Sort'),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final date = (c.searchList[index].date == null)
                              ? "N/A"
                              : DateFormat.yMMMd()
                                  .format(c.searchList[index].date!);
                          return ListTile(
                            onTap: () {
                              Get.to(() => ProgramDetails(
                                    data: c.searchList[index],
                                  ))?.then((value) => c.onInit());
                            },
                            leading: CircleAvatar(
                                child: Text((index + 1).toString())),
                            title: Text(c.searchList[index].name ?? "N/A"),
                            subtitle: Text(date),
                            trailing: Text(
                                "${c.searchList[index].duration.toString()} Hours"),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: c.searchList.length),
                  ),
                ],
              ));
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
