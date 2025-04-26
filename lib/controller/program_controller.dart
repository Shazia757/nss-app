import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import '../model/programs_model.dart';

class ProgramListController extends GetxController {
  RxList<Program> programsList = <Program>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getPrograms();
    super.onInit();
  }

  void getPrograms() {
    isLoading.value = true;
    Api().allPrograms().then(
      (value) {
        programsList.assignAll(value?.programs ?? []);
        isLoading.value = false;
      },
    );
  }
}

class AddProgramController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  DateTime? date;
  addProgram() {
    Api()
        .addProgram(Program(
            name: nameController.text,
            date: date,
            duration: int.tryParse(durationController.text),
            createdBy: LocalStorage().readUser().admissionNo))
        .then(
      (value) {
        if (value?.status ?? false == true) {
          Get.snackbar(
              "Success", value?.message ?? "Program added successfully");
          Get.back();
        } else {
          Get.snackbar("Error", value?.message ?? 'Failed to add program.');
        }
      },
    );
  }

  updateProgram(int id) {
    Api().updateProgram({
      'name': nameController.text,
      'date': date,
      'duration': int.tryParse(durationController.text),
      'updated_by': LocalStorage().readUser().admissionNo,
      'id': id
    }).then(
      (value) {
        if (value?.status == true) {
          Get.back();
          Get.snackbar(
              "Success", value?.message ?? "Program updated successfully.");
        } else {
          Get.snackbar('Error', value?.message ?? 'Failed to update program.');
        }
      },
    );
  }

  deleteProgram(int id) {
    Api().deleteProgram(id).then(
      (value) {
        if (value?.status == true) {
          Get.back();
          Get.snackbar(
              "Success", value?.message ?? "Program deleted successfully.");
        } else {
          Get.snackbar("Error", value?.message ?? 'Failed to delete program.');
        }
      },
    );
  }

  bool onSubmitProgramValidation() {
    if (nameController.text.isEmpty) {
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
    if (descController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add description');
      return false;
    }
    return true;
  }
}
