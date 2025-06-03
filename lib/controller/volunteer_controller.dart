import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/volunteers/profile_screen.dart';

class VolunteerController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController depController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  var isUpdateButtonLoading = false.obs;
  var isDeleteButtonLoading = false.obs;

  DateTime? dob;
  final api = Api();
  RxString role = 'vol'.obs;

  void addVolunteer() async {
    isUpdateButtonLoading.value = true;
    api
        .addVolunteer(Users(
            admissionNo: admissionNoController.text,
            name: nameController.text,
            email: emailController.text,
            createdBy: LocalStorage().readUser().admissionNo,
            phoneNo: phoneController.text,
            dob: dob,
            department: depController.text,
            role: role.value,
            rollNo: rollNoController.text,
            year: yearController.text))
        .then(
      (value) {
        isUpdateButtonLoading.value = false;
        if (value?.status ?? false) {
          Get.back();
          Get.back();
          CustomWidgets.showSnackBar(
              'Success', value?.message ?? 'Volunteer added successfully.');
        } else {
          CustomWidgets.showSnackBar(
              'Error', value?.message ?? 'Failed to add volunteer.');
        }
      },
    );
  }

  void updateVolunteer() async {
    isUpdateButtonLoading.value = true;
    api.updateVolunteer({
      'admission_number': admissionNoController.text,
      'name': nameController.text,
      'email': emailController.text,
      'updated_by': LocalStorage().readUser().admissionNo,
      'phone_number': phoneController.text,
      'date_of_birth': dob.toString(),
      'department': depController.text,
      'roll_number': rollNoController.text,
      'role': role.value,
      'year': yearController.text
    }).then(
      (response) {
        isUpdateButtonLoading.value = false;
        if (response?.status == true) {
          Get.back();
          Get.back();
          CustomWidgets.showSnackBar('Success',
              response?.message ?? 'Volunteer updated successfully.');
        } else {
          CustomWidgets.showSnackBar(
              'Error', response?.message ?? 'Failed to update volunteer.');
        }
      },
    );
  }

  void deleteVolunteer() async {
    isDeleteButtonLoading.value = true;
    api.deleteVolunteer(admissionNoController.text).then(
      (response) {
        isDeleteButtonLoading.value = false;

        if (response?.status == true) {
          Get.back();
          Get.back();
          CustomWidgets.showSnackBar("Success",
              response?.message ?? "Volunteer deleted successfully.");
        } else {
          CustomWidgets.showSnackBar(
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
    dob = user.dob;
    role.value = user.role ?? 'vol';
    yearController.text = user.year ?? "";
  }

  void clearTextFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    depController.clear();
    rollNoController.clear();
    admissionNoController.clear();
    dobController.clear();
    yearController.clear();
  }

  bool onSubmitVolValidation() {
    if (nameController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter name');
      return false;
    }
    if (emailController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter email');
      return false;
    }
    if (phoneController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter phone number');
      return false;
    }
    if (depController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add department');
      return false;
    }
    if (rollNoController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add roll number');
      return false;
    }
    if (admissionNoController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add admission number');
      return false;
    }
    if (dobController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add date of birth');
      return false;
    }
    if (yearController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add year of study');
      return false;
    }
    return true;
  }
}

class VolunteerListController extends GetxController {
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = true.obs;
  RxList<Volunteer> usersList = <Volunteer>[].obs;
  RxList<Volunteer> searchList = <Volunteer>[].obs;
  RxList<String> departmentList = <String>[].obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    isLoading.value = true;
    Api().getVolunteers().then(
      (value) {
        usersList.assignAll(value?.data ?? []);
        searchList.assignAll(usersList);
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

  void onSearchTextChanged(String value) {
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
    }
  }
}
