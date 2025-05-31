import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/program/program_list_screen.dart';
import '../model/programs_model.dart';

class ProgramListController extends GetxController {
  RxList<Program> programsList = <Program>[].obs;
  RxList<Program> searchList = <Program>[].obs;
  RxBool isLoading = true.obs;
  TextEditingController searchController = TextEditingController();
  RxString date='oldest'.obs;

  @override
  void onInit() {
    getPrograms();
    super.onInit();
  }

  void getPrograms() async {
    isLoading.value = true;
    Api().allPrograms().then(
      (value) {
        programsList.assignAll(value?.programs ?? []);
        searchList.assignAll(programsList);
        isLoading.value = false;
      },
    );
  }

  void onSearchTextChanged(String searchText) async {
    if (searchText.isEmpty) {
      searchController.clear();
      searchList.assignAll(programsList);
    } else {
      final filtered = programsList.where((program) {
        final name = program.name?.toLowerCase() ?? '';
        return name.contains(searchText.toLowerCase());
      }).toList();

      searchList.assignAll(filtered);
    }
  }

  void sortByDate() {
    if (date.value == 'oldest') {
      searchList.sort((a, b) => a.date!.compareTo(b.date!));
    } else {
      searchList.sort((a, b) => b.date!.compareTo(a.date!));
    }
  }
}

class AddProgramController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  var isUpdateButtonLoading = false.obs;
  var isDeleteButtonLoading = false.obs;
  DateTime? date;

  

  addProgram() {
    isUpdateButtonLoading.value = true;
    Api()
        .addProgram(Program(
            name: nameController.text,
            date: date,
            duration: int.tryParse(durationController.text),
            createdBy: (LocalStorage().readUser().admissionNo).toString(),
            description: descController.text))
        .then(
      (value) {
        isUpdateButtonLoading.value = false;
        if (value?.status == true) {
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Program added successfully");
        } else {
          CustomWidgets.showSnackBar(
              "Error", value?.message ?? 'Failed to add program.');
        }
      },
    );
  }

  updateProgram(int id) {
    isUpdateButtonLoading.value = true;
    Api().updateProgram({
      'name': nameController.text,
      'date': date.toString(),
      'duration': durationController.text,
      'updated_by': LocalStorage().readUser().admissionNo,
      'id': id.toString(),
      'description': descController.text
    }).then(
      (value) {
        isUpdateButtonLoading.value = false;
        if (value?.status == true) {
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Program updated successfully.");
        } else {
          CustomWidgets.showSnackBar(
              'Error', value?.message ?? 'Failed to update program.');
        }
      },
    );
  }

  deleteProgram(int id) {
    isDeleteButtonLoading.value = true;
    Api().deleteProgram(id).then(
      (value) {
        if (value?.status == true) {
          isDeleteButtonLoading.value = false;
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Program deleted successfully.");
          Get.to(() => ProgramsScreen());
        } else {
          CustomWidgets.showSnackBar(
              "Error", value?.message ?? 'Failed to delete program.');
        }
      },
    );
  }

  bool onSubmitProgramValidation() {
    if (nameController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter program name');
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
    if (descController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add description');
      return false;
    }
    return true;
  }

  void setUpdateData(Program program) {
    nameController.text = program.name ?? '';
    descController.text = program.description ?? '';
    date = program.date;
    log(date.toString());
    dateController.text =
        (program.date) != null ? DateFormat.yMMMd().format(program.date!) : '';
    durationController.text =
        (program.duration) != null ? (program.duration ?? 0).toString() : '';
  }

  void clearTextFields() {
    nameController.clear();
    durationController.clear();
    descController.clear();
    dateController.clear();
  }
}
