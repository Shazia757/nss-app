import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/enrollment_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import '../model/programs_model.dart';
import '../view/program/students_enrollment_screen.dart';

class ProgramListController extends GetxController {
  RxList<Program> programsList = <Program>[].obs;
  RxList<Program> searchList = <Program>[].obs;
  RxBool isLoading = false.obs;
  RxBool isButtonLoading = false.obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  RxString date = 'oldest'.obs;
  RxList<ProgramEnrollmentDetails> enrollmentList =
      <ProgramEnrollmentDetails>[].obs;
  RxList<Volunteer> selectedVolList = <Volunteer>[].obs;

  DateTime programDate = DateTime.now();
  RxString showProgramDate = ''.obs;

  @override
  void onInit() {
    getPrograms();
    super.onInit();
  }

  void selectAllVolunteers() {
    selectedVolList.clear();
    for (ProgramEnrollmentDetails vol in enrollmentList) {
      if (vol.volunteer != null) {
        selectedVolList.add(vol.volunteer!);
      }
    }
  }

  void getPrograms() async {
    isLoading.value = true;
    Api().allPrograms().then(
      (value) {
        programsList.assignAll(value?.programs ?? []);
        searchList.assignAll(programsList);
        searchList.sort((a, b) => b.date!.compareTo(a.date!));
        isLoading.value = false;
      },
    );
  }

  void addAttendance(Program? program) async {
    isLoading.value = true;
    bool response = true;
    for (Volunteer e in selectedVolList) {
      final value = await Api().addAttendance({
        'date': programDate.toString(),
        'hours': durationController.text,
        'program_name': program?.name,
        'volunteer': e.admissionNo,
      });
      if (!(value?.status ?? true)) response = false;
    }
    isLoading.value = false;
    //
    // .then(
    //   (value) {
    //
    //
    //   },
    // );
    // }
    if (response) {
      Get.back();
      Get.back();
      CustomWidgets.showSnackBar('Success', 'Attendance added successfully');
    } else {
      CustomWidgets.showSnackBar('Error', 'Some attendance not added');
    }
  }

  void getEnrolledStudents(Program? program, RxBool loading) async {
    loading.value = true;
    Api().getEnrolledStudents(program?.id).then(
      (value) {
        if ((value?.enrollmentList ?? []).isEmpty) {
          CustomWidgets.showToast('No volunteers enrolled');
        } else {
          enrollmentList.assignAll(value?.enrollmentList?.toList() ?? []);
          selectAllVolunteers();
          durationController.text = "${program?.duration}";
          programDate = program?.date ?? DateTime.now();
          showProgramDate.value = DateFormat.yMMMd().format(programDate);

          Get.to(() => StudentsEnrollmentScreen(data: program));
        }
        loading.value = false;
      },
    );
  }

  void onSearchTextChanged(String searchText) async {
    if (searchText.isEmpty) {
      searchController.clear();
      searchList.assignAll(programsList);
      searchList.sort((a, b) => b.date!.compareTo(a.date!));
    } else {
      final filtered = programsList.where((program) {
        final name = program.name?.toLowerCase() ?? '';
        return name.contains(searchText.toLowerCase());
      }).toList();

      searchList.assignAll(filtered);
      searchList.sort((a, b) => b.date!.compareTo(a.date!));
    }
  }

  void sortByDate() {
    (date.value == 'oldest')
        ? searchList.sort((a, b) => a.date!.compareTo(b.date!))
        : searchList.sort((a, b) => b.date!.compareTo(a.date!));
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
            description: descController.text))
        .then(
      (value) {
        isUpdateButtonLoading.value = false;
        if (value?.status ?? false) {
          Get.back();
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
        if (value?.status??false) {
          Get.back();
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
          Get.back();
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Program deleted successfully.");
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
