import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/volunteer_model.dart';
import '../view/home_screen.dart';

class AttendanceController extends GetxController {
  TextEditingController programNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  RxList<Volunteer> usersList = <Volunteer>[].obs;
  RxList<Volunteer> searchList = <Volunteer>[].obs;
  RxList<Volunteer> selectedVolList = <Volunteer>[].obs;

  RxList<Attendance> attendanceList = <Attendance>[].obs;
  RxList<String> programsList = <String>[].obs;
  RxInt sortColumnIndex = 0.obs;
  RxBool isAscending = true.obs;
  RxString programName = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isProgramLoading = true.obs;
  RxInt totalHours = 0.obs;
  RxInt totalPrograms = 0.obs;
  DateTime? date;

  @override
  void onInit() {
    getUsers();
    getPrograms();
    super.onInit();
  }

  void getUsers() {
    isLoading.value = true;
    Api().listVolunteer().then(
      (value) {
        usersList.assignAll(value?.data ?? []);
        searchList.assignAll(usersList);
        isLoading.value = false;
      },
    );
  }

  void getPrograms() {
    isProgramLoading.value = true;
    Api().programNames().then(
      (value) {
        value?.programs?.toSet();
        programsList.assignAll(value?.programs?.toSet() ?? []);
        isProgramLoading.value = false;
      },
    );
  }

  void getAttendance(String id) async {
    isLoading.value = true;
    Api().getAttendance(id).then(
      (value) {
        attendanceList.assignAll(value?.attendance ?? []);
        log(value.toString());
        isLoading.value = false;
        totalHours.value = attendanceList.fold(
            0, (sum, element) => (sum += element.hours ?? 0));
        totalPrograms.value = attendanceList.length;
      },
    );
  }

  bool onSubmitAttendanceValidation() {
    if (programNameController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter program name');
      return false;
    }
    if (dateController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter date');
      return false;
    }
    if (durationController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter duration');
      return false;
    }
    if (selectedVolList.isEmpty) {
      Get.snackbar('Invalid', 'Please select volunteers');
      return false;
    }
    return true;
  }

  onSubmitAttendance() {
    isLoading.value = true;
    for (Volunteer e in selectedVolList) {
      Api().addAttendance({
        'date': date.toString(),
        'hours': int.tryParse(durationController.text),
        'marked_by': (LocalStorage().readUser().admissionNo).toString(),
        'program_name': programNameController.text,
        'admission_number': e.admissionNo.toString(),
      }).then(
        (value) {
          isLoading.value = false;
          if (value?.status == true) {
            Get.offAll(() => HomeScreen());
            Get.snackbar(
                'Success', value?.message ?? 'Attendance added successfully');
          } else {
            Get.snackbar(
                'Error', value?.message ?? 'Failed to add attendance.');
          }
        },
      );
    }
  }

  deleteAttendance(int id) {
    Api().deleteAttendance(id).then(
      (value) {
        log(value?.message ?? "Program deleted successfully.");
        if (value?.status == true) {
          Get.back();
          Get.snackbar(
              "Success", value?.message ?? "Attendance deleted successfully.");
        } else {
          Get.snackbar(
              "Error", value?.message ?? 'Failed to delete attendance.');
        }
      },
    );
  }

  // void sort(int columnIndex, bool ascending) {
  //   sortColumnIndex.value = columnIndex;
  //   isAscending.value = ascending;

  //   if (columnIndex == 0) {
  //     attendanceList.sort((a, b) =>
  //         ascending ? a.date!.compareTo(b.date!) : b.date!.compareTo(a.date!));
  //   } else if (columnIndex == 1) {
  //     attendanceList.sort((a, b) => ascending
  //         ? (a.name ?? '').compareTo(b.name ?? '')
  //         : (b.name ?? '').compareTo(a.name ?? ''));
  //   } else if (columnIndex == 2) {
  //     attendanceList.sort((a, b) {
  //       final hoursA = a.hours;
  //       final hoursB = b.hours;

  //       if (hoursA == null && hoursB == null) return 0;
  //       if (hoursA == null) return 1;
  //       if (hoursB == null) return -1;

  //       return ascending ? hoursA.compareTo(hoursB) : hoursB.compareTo(hoursA);
  //     });
  //   }
  //   attendanceList.refresh();
  // }

  void onSearchTextChanged(String value) async {
    if (value.isEmpty) {
      searchController.clear();
      searchList.assignAll(usersList);
    } else {
      final filtered = usersList.where((volunteer) {
        final name = volunteer.name?.toLowerCase() ?? '';
        final admnNo = volunteer.admissionNo ?? '';

        return admnNo.contains(value.toLowerCase()) || name.contains(value);
      }).toList();

      searchList.assignAll(filtered);
      log(searchList.toString());
    }
  }
}
