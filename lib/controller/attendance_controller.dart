import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/attendance_model.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/volunteer_model.dart';
import '../view/home_screen.dart';

class AttendanceController extends GetxController {
  TextEditingController programNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  RxList<Volunteer> usersList = <Volunteer>[].obs;
  RxList<String> selectedVolList = <String>[].obs;
  RxList<Attendance> attendanceList = <Attendance>[].obs;
  RxList<Program> programsList = <Program>[].obs;
  RxString programName = ''.obs;
  RxBool isLoading = true.obs;
  RxString totalHours = '0'.obs;
  RxString totalPrograms = '0'.obs;

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
    isLoading.value = true;
    Api().programNames().then(
      (value) {
        programsList.assignAll(value?.programs ?? []);
        isLoading.value = false;
      },
    );
  }

  void getAttendance(String id) async {
    isLoading.value = true;
    Api().getAttendance(id).then(
      (value) {
        attendanceList.assignAll(value?.attendance ?? []);
        isLoading.value = false;
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

  onSubmitAttendance(int admissionNo) {
    Api()
        .addAttendance(Attendance(
      date: DateTime.tryParse(dateController.text),
      hours: int.tryParse(durationController.text),
      markedBy: LocalStorage().readUser().admissionNo,
      name: programNameController.text,
      admissionNo: admissionNo,
    ))
        .then(
      (value) {
        if (value?.status == true) {
          Get.snackbar(
              'Success', value?.message ?? 'Attendance added successfully');
          Get.offAll(() => HomeScreen());
        } else {
          Get.snackbar('Error', value?.message ?? 'Failed to add attendance.');
        }
      },
    );
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
