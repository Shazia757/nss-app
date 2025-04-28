import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/volunteers/profile_screen.dart';

class VolunteerController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController depController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  DateTime? dob;
  final api = Api();

  void addVolunteer() async {
    api
        .addVolunteer(Users(
      admissionNo: admissionNoController.text,
      name: nameController.text,
      email: emailController.text,
      createdBy: LocalStorage().readUser().admissionNo,
      phoneNo: phoneController.text,
      dob:  DateTime.parse(dobController.text),
      department: depController.text,
      role: 'vol',
      rollNo: rollNoController.text,
    ))
        .then(
      (value) {
        if (value?.status ?? false == true) {
          Get.back();
          Get.snackbar(
              'Success', value?.message ?? 'Volunteer added successfully.');
        } else {
          Get.snackbar('Error', value?.message ?? 'Failed to add volunteer.');
        }
      },
    );
  }

  void updateVolunteer() async {
    api.updateVolunteer({
      'admission_number': admissionNoController.text,
      'name': nameController.text,
      'email': emailController.text,
      'updated_by': LocalStorage().readUser().admissionNo,
      'phone_number': phoneController.text,
      'date_of_birth': dob,
      'department': depController.text,
      'roll_number': rollNoController.text,
    }).then(
      (response) {
        if (response?.status == true) {
          Get.back();
          Get.snackbar('Success',
              response?.message ?? 'Volunteer updated successfully.');
        } else {
          Get.snackbar(
              'Error', response?.message ?? 'Failed to update volunteer.');
        }
      },
    );
  }

  void deleteVolunteer() async {
    api.deleteVolunteer(admissionNoController.text).then(
      (response) {
        if (response?.status == true) {
          Get.back();
          Get.snackbar("Success",
              response?.message ?? "Volunteer deleted successfully.");
        } else {
          Get.snackbar(
              "Error", response?.message ?? "Failed to delete volunteer.");
        }
      },
    );
  }

  void setUpdateData(Users user) {
    nameController.text = user.name ?? "";
    emailController.text = user.email ?? "";
    phoneController.text = user.phoneNo ?? "";
    depController.text = user.department ?? "";
    rollNoController.text = user.rollNo?.toString() ?? "";
    admissionNoController.text = user.admissionNo ?? "";
    dobController.text =
        (user.dob != null) ? DateFormat.yMMMd().format(user.dob!) : "";
  }

  void clearTextFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    depController.clear();
    rollNoController.clear();
    admissionNoController.clear();
    dobController.clear();
  }

  bool onSubmitVolValidation() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter program name');
      return false;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter email');
      return false;
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter phone number');
      return false;
    }
    if (depController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add department');
      return false;
    }
    if (rollNoController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add roll number');
      return false;
    }
    if (admissionNoController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add admission number');
      return false;
    }
    if (dobController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add date of birth');
      return false;
    }
    return true;
  }
}

class VolunteerListController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Volunteer> usersList = <Volunteer>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    isLoading.value = true;
    Api().listVolunteer().then(
      (value) {
        usersList.assignAll(value?.data ?? []);
        isLoading.value = false;
      },
    );
  }

  void updateVolunteer(String? admissionNo) {
    Api().volunteerDetails(admissionNo!).then(
      (value) {
        Get.to(VolunteerAddScreen(
          isUpdateScreen: true,
          user: value!.volunteerDetails,
        ));
      },
    );
  }
}
