import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/controller/home_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/attendance/manage_attendance_screen.dart';
import 'package:nss/view/attendance/view_attendance_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/issues/user_issues_screen.dart';
import 'package:nss/view/program/program_list_screen.dart';
import 'package:nss/view/volunteers/profile_screen.dart';
import 'package:nss/view/volunteers/volunteer_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController c = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          "Welcome, ${LocalStorage().readUser().name}",
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (MediaQuery.of(context).size.width > 800) ...[
            Wrap(
              spacing: 10,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => ScreenIssues()),
                  child: Text("Issues"),
                  //  icon: Icon(Icons.bug_report_outlined),
                ),
                TextButton(
                  child: Text("Profile"),

                  onPressed: () => Get.to(() => VolunteerAddScreen()),
                  //   icon: Icon(Icons.person_2_outlined),
                ),
              ],
            ),
          ],
          Visibility(
            visible: (LocalStorage().readUser().role == 'sec') &&
                (MediaQuery.of(context).size.width < 800),
            child: IconButton(
              onPressed: () => showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) => _upcomingEvents(c, context),
              ),
              icon: Icon(Icons.notifications_active_outlined, size: 30),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 800;

          return SafeArea(
            minimum: EdgeInsets.all(16),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _headerSection(context),
                            SizedBox(height: 20),
                            _mottoSection(context),
                            SizedBox(height: 20),
                            _gridMenu(context, isDesktop),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: _upcomingEvents(c, context),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _headerSection(context),
                      _mottoSection(context),
                      SizedBox(height: 20),
                      _gridMenu(context, isDesktop),
                      SizedBox(height: 20),
                      Visibility(
                        visible: LocalStorage().readUser().role != 'sec',
                        child: Expanded(child: _upcomingEvents(c, context)),
                      ),
                    ],
                  ),
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width > 800
          ? null
          : CustomNavBar(currentIndex: 0),
    );
  }

  Widget _mottoSection(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 31, 21, 81),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.volunteer_activism,
                color: Theme.of(context).colorScheme.onPrimary),
            SizedBox(width: 8),
            Text(
              "Not Me But You",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 800;
        return isDesktop
            ? Row(
                children: [
                  Image.asset("assets/logos/logo.png", height: 80),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NSS Farook College",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Let's make a difference today",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Image.asset("assets/logos/logo.png", height: 80),
                  SizedBox(height: 10),
                  Text(
                    "NSS Farook College",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Let's make a difference today",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              );
      },
    );
  }

  Widget _gridMenu(BuildContext context, bool isDesktop) {
    List<Widget> children = [];

    switch (LocalStorage().readUser().role) {
      case 'sec':
        children.add(_menuCard(
            "View Attendance",
            Icons.event,
            context,
            () => Get.to(() => ViewAttendanceScreen(
                isViewAttendance: true,
                id: LocalStorage().readUser().admissionNo!)),
            [
              Colors.teal.shade900,
              Colors.teal.shade600,
              Colors.teal.shade300
            ]));
        children.add(_menuCard("Programs", Icons.upcoming_outlined, context,
            () => Get.to(() => ProgramsScreen()), [
          Theme.of(context).colorScheme.onErrorContainer,
          Theme.of(context).colorScheme.error
        ]));
        children.add(_menuCard("Manage Volunteers", Icons.manage_accounts,
            context, () => Get.to(() => VolunteersListScreen()), [
          Colors.blue.shade900,
          Colors.blue.shade600,
          Colors.blue.shade300
        ]));
        children.add(_menuCard("Manage Attendance", Icons.edit_calendar,
            context, () => Get.to(() => ManageAttendanceScreen()), [
          Colors.green.shade900,
          Colors.green.shade600,
          Colors.green.shade300
        ]));
        break;

      case 'po':
        children.add(_menuCard("Programs", Icons.upcoming_outlined, context,
            () => Get.to(() => ProgramsScreen()), [
          Theme.of(context).colorScheme.onErrorContainer,
          Theme.of(context).colorScheme.error
        ]));
        children.add(_menuCard("Manage Volunteers", Icons.manage_accounts,
            context, () => Get.to(() => VolunteersListScreen()), [
          Colors.blue.shade900,
          Colors.blue.shade600,
          Colors.blue.shade300
        ]));
        children.add(_menuCard("Manage Attendance", Icons.edit_calendar,
            context, () => Get.to(() => ManageAttendanceScreen()), [
          Colors.green.shade900,
          Colors.green.shade600,
          Colors.green.shade300
        ]));
        break;

      default:
        children.add(_menuCard(
            "View Attendance",
            Icons.event,
            context,
            () {
              
              Get.to(() => ViewAttendanceScreen(
                isViewAttendance: true,
                id: LocalStorage().readUser().admissionNo!));
            },
            [
              Colors.teal.shade900,
              Colors.teal.shade600,
              Colors.teal.shade300
            ]));
        children.add(_menuCard("Programs", Icons.upcoming_outlined, context,
            () => Get.to(() => ProgramsScreen()), [
          Theme.of(context).colorScheme.onErrorContainer,
          Theme.of(context).colorScheme.error
        ]));
    }

    return Expanded(
      child: SingleChildScrollView(
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: isDesktop
              ? 4
              : LocalStorage().readUser().role == 'po'
                  ? 3
                  : 2,
          childAspectRatio: isDesktop ? 1.2 : 1,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: children,
        ),
      ),
    );
  }

  Widget _menuCard(String title, IconData icon, BuildContext context,
      VoidCallback onTap, List<Color> colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              SizedBox(height: 10),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingEvents(HomeController c, BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active,
                  color: Colors.amber,
                ),
                SizedBox(width: 5),
                Obx(() => Text("Upcoming Events (${c.upcomingPrograms.length})",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              ],
            ),
          ),
          Obx(() => Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => c.fetchUpcomingPrograms(),
                  child: c.isLoading.value
                      ? CircularProgressIndicator()
                      : c.upcomingPrograms.isEmpty
                          ? Center(child: Text("No upcoming programs"))
                          : ListView.separated(
                              itemCount: c.upcomingPrograms.length,
                              itemBuilder: (context, index) {
                                final program = c.upcomingPrograms[index];
                                final date =
                                    DateFormat.yMMMd().format(program.date!);
                                return ListTile(
                                  title: Text(program.name ?? ""),
                                  subtitle: Text(date),
                                  trailing: Text("${program.duration} Hours"),
                                );
                              },
                              separatorBuilder: (context, index) => Divider(),
                            ),
                ),
              )),
        ],
      ),
    );
  }
}
