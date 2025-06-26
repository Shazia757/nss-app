import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

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
  String programName = '';
  RxBool isLoading = true.obs;
  RxBool isAttendanceLoading = false.obs;

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
    Api().getVolunteers().then(
      (value) {
        usersList.assignAll(value?.data ?? []);
        searchList.assignAll(usersList);
        searchList.sort((a, b) => a.name!.compareTo(b.name!));
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
    isAttendanceLoading.value = true;
    Api().getAttendance(id).then(
      (value) {
        attendanceList.assignAll(value?.attendance ?? []);
        attendanceList.sort((a, b) => b.date!.compareTo(a.date!));

        log(attendanceList.toString());
        isLoading.value = false;
        isAttendanceLoading.value = false;

        totalHours.value = attendanceList.fold(
            0, (sum, element) => (sum += element.hours ?? 0));
        totalPrograms.value = attendanceList.length;
      },
    );
  }

  bool onSubmitAttendanceValidation() {
    if ((programName.isEmpty) || (programName != programNameController.text)) {
      CustomWidgets.showSnackBar('Invalid', 'Please select valid program ');
      return false;
    }
    if (dateController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter date');
      return false;
    }
    if (durationController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter duration');
      return false;
    }
    if (selectedVolList.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please select volunteers');
      return false;
    }
    return true;
  }

  onSubmitAttendance() {
    isLoading.value = true;
    bool response = true;

    for (Volunteer e in selectedVolList) {
      Api().addAttendance({
        'date': date.toString(),
        'hours': int.tryParse(durationController.text),
        'marked_by': (LocalStorage().readUser().admissionNo).toString(),
        'program_name': programName,
        'admission_number': e.admissionNo.toString(),
      }).then(
        (value) {
          isLoading.value = false;
          if (!(value?.status ?? true)) {
            response = false;
          }
        },
      );
    }
    if (response) {
      Get.back();
      Get.back();
      CustomWidgets.showSnackBar('Success', 'Attendance added successfully');
    } else {
      CustomWidgets.showSnackBar('Error', 'Some attendance not added');
    }
  }

  deleteAttendance(int id) {
    Api().deleteAttendance(id).then(
      (value) {
        if (value?.status == true) {
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Attendance deleted successfully.");
        } else {
          CustomWidgets.showSnackBar(
              "Error", value?.message ?? 'Failed to delete attendance.');
        }
      },
    ).then((value) => onInit());
  }

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
