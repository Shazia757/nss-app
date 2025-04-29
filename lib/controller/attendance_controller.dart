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
  RxList<Volunteer> selectedVolList = <Volunteer>[].obs;

  RxList<Attendance> attendanceList = <Attendance>[].obs;
  RxList<String> programsList = <String>[].obs;
  RxString programName = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isProgramLoading = true.obs;
  RxInt totalHours = 0.obs;
  RxInt totalPrograms = 0.obs;
  DateTime? date;

  void getUsers() {
    isLoading.value = true;
    Api().listVolunteer().then(
      (value) {
        usersList.assignAll(value?.data ?? []);
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
    isLoading.value=true;
    for (Volunteer e in selectedVolList) {
      Api().addAttendance({
        'date': date.toString(),
        'hours': int.tryParse(durationController.text),
        'marked_by': (LocalStorage().readUser().admissionNo).toString(),
        'program_name': programNameController.text,
        'admission_number': e.admissionNo.toString(),
      }).then(
        (value) {
          isLoading.value=false;
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
}
