import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nss/controller/program_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/common_pages/loading.dart';
import 'package:nss/view/common_pages/no_data.dart';
import 'package:nss/view/program/add_program_screen.dart';
import 'package:nss/view/program/students_enrolled.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProgramListController c = Get.put(ProgramListController());

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Obx(() => (!c.isLoading.value)
                ? AppBar(
                    title: Text("Programs"),
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    actions: [
                      MenuAnchor(
                        menuChildren: [
                          MenuItemButton(
                            child: Text("Oldest"),
                            onPressed: () {
                              c.date.value = 'oldest';
                              c.sortByDate();
                            },
                          ),
                          MenuItemButton(
                            child: Text("Latest"),
                            onPressed: () {
                              c.date.value = 'latest';
                              c.sortByDate();
                            },
                          ),
                        ],
                        builder: (context, controller, child) {
                          return TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            label: Text(
                              'Sort',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            onPressed: () => (controller.isOpen)
                                ? controller.close()
                                : controller.open(),
                            icon: Icon(
                              Icons.swap_vert,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          );
                        },
                      ),
                      // IconButton(onPressed: () => c.onInit(), icon: Icon(Icons.refresh)),
                    ],
                  )
                : SizedBox())),
        body: Obx(
          () {
            if (c.isLoading.value) {
              return LoadingScreen();
            } else if (c.programsList.isEmpty) {
              return RefreshIndicator(
                  onRefresh: () async => c.onInit(),
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        NoDataPage(title: 'No programs found'),
                      ],
                    ),
                  ));
            }
            return RefreshIndicator.adaptive(
                onRefresh: () async => c.onInit(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomWidgets().searchBar(
                              constraints: BoxConstraints.tight(Size(350, 50)),
                              leading: Icon(Icons.search),
                              controller: c.searchController,
                              hintText: 'Search Program',
                              onChanged: (value) =>
                                  c.onSearchTextChanged(value),
                              visible: c.searchController.text.isNotEmpty,
                              onPressedCancel: () => c.onSearchTextChanged(''),
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            RxBool isExpanded = false.obs;
                            final date = (c.searchList[index].date == null)
                                ? "N/A"
                                : DateFormat.yMMMd()
                                    .format(c.searchList[index].date!);
                            return InkWell(
                              onTap: LocalStorage.isAdmin
                                  ? () => Get.to(() => AddProgramScreen(
                                        isUpdate: true,
                                        program: c.searchList[index],
                                      ))?.then((value) => c.onInit())
                                  : null,
                              child: Card.outlined(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, bottom: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              date,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Text(
                                              "${c.searchList[index].duration.toString()} hours",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, bottom: 8),
                                        child: Text(
                                          c.searchList[index].name ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, bottom: 8),
                                        child: Obx(() => Wrap(
                                              children: [
                                                Text(
                                                  c.searchList[index]
                                                          .description ??
                                                      "",
                                                  maxLines: (isExpanded.value)
                                                      ? null
                                                      : 3,
                                                  overflow: (isExpanded.value)
                                                      ? TextOverflow.visible
                                                      : TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800),
                                                ),
                                                if (((c
                                                            .searchList[index]
                                                            .description
                                                            ?.length ??
                                                        0) >
                                                    200))
                                                  TextButton(
                                                    onPressed: () =>
                                                        isExpanded.value =
                                                            !isExpanded.value,
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.zero),
                                                    child: Text(
                                                      isExpanded.value
                                                          ? 'show less'
                                                          : 'show more',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w100),
                                                    ),
                                                  ),
                                                if (LocalStorage()
                                                        .readUser()
                                                        .role !=
                                                    'vol')
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: TextButton(
                                                        onPressed: () {
                                                          c.getEnrolledStudents(
                                                              c
                                                                  .searchList[
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                          Get.to(() =>
                                                              StudentsEnrolled(
                                                                  data: c.searchList[
                                                                      index]));
                                                        },
                                                        child: Text(
                                                            'Students Enrolled')),
                                                  )
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: c.searchList.length),
                    ),
                  ],
                ));
          },
        ),
        floatingActionButton: (LocalStorage().readUser().role != 'vol')
            ? Obx(() => (c.isLoading.isFalse)
                ? FloatingActionButton(
                    onPressed: () =>
                        Get.to(() => AddProgramScreen(isUpdate: false))
                            ?.then((value) => c.onInit()),
                    child: Icon(Icons.add),
                  )
                : SizedBox())
            : SizedBox());
  }
}
