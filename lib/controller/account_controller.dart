import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/authentication/login_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/home_screen.dart';

class AccountController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  RxBool isObscure = true.obs;
  RxBool isOldPassObscure = true.obs;
  RxBool isNewPassObscure = true.obs;
  RxBool isConfirmPassObscure = true.obs;
  RxString reason = 'No longer needed'.obs;

  final api = Api();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  onInit() {
    if (kDebugMode) {
      userNameController.text = 'sec@fc';
      passwordController.text = '0000';
    }

    super.onInit();
  }

  Future<void> login() async {
    errorMessage.value = '';

    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields!';
      CustomWidgets.showSnackBar('Error', 'Please fill all fields!');
      return;
    }
    isLoading.value = true;

    api.login({'admission_number': userName, 'password': password}).then(
      (response) async {
        if (response?.status == true && response?.data.admissionNo != null) {
          await LocalStorage().writeUser(response?.data ?? Users());
          CustomWidgets.showSnackBar('Welcome', '${response?.data.name}', icon: Icon(Icons.login));
          Get.offAll(() => HomeScreen());
        } else {
          errorMessage.value = response?.message ?? 'Failed to login!';
          CustomWidgets.showSnackBar('Error', errorMessage.value);
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> resetPassword(String id) async {
    if ((newPassController.text.trim().isEmpty)) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter password.');
    } else if (confirmPassController.text.trim().isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Confirm password is empty.');
    } else {
      if (newPassController.text == confirmPassController.text) {
        isLoading.value = true;
        api.resetPassword({'admission_number': id, 'new_password': confirmPassController.text}).then(
          (value) {
            isLoading.value = false;
            if (value?.status ?? false) {
              passwordController.clear();
              newPassController.clear();
              confirmPassController.clear();
              Get.back();
              CustomWidgets.showSnackBar('Success', value?.message ?? 'Password Changed Successfully');
            } else {
              CustomWidgets.showSnackBar('Error', value?.message ?? 'Password not changed.');
            }
          },
        );
      } else {
        CustomWidgets.showSnackBar('Invalid', 'Passwords do not match');
      }
    }
  }

  Future<void> changePassword(String id) async {
    if ((oldpasswordController.text.trim().isEmpty)) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter old password.');
    } else if ((newPassController.text.trim().isEmpty)) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter new password.');
    } else if (confirmPassController.text.trim().isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Confirm password is empty.');
    } else {
      if (newPassController.text == confirmPassController.text) {
        isLoading.value = true;
        api.changePassword({'admission_number': id, 'old_password': oldpasswordController.text, 'new_password': confirmPassController.text}).then(
          (value) {
            isLoading.value = false;
            if (value?.status == true) {
              Get.to(() => LoginScreen());
              CustomWidgets.showSnackBar('Success', value?.message ?? 'Password Changed.');
            } else {
              CustomWidgets.showSnackBar('Error', value?.message ?? 'Password not changed.');
            }
          },
        );
      } else {
        CustomWidgets.showSnackBar('Invalid', 'Passwords do not match');
      }
    }
  }

  void deleteAccount() {
    if (reasonController.text.trim().length >= 20) {
      isLoading.value = true;
      final data = {
        'subject': 'Account delete request',
        'description': reasonController.text,
        'assigned_to': 'sec',
        'created_by': (LocalStorage().readUser().admissionNo).toString(),
        'updated_by': (LocalStorage().readUser().admissionNo).toString(),
      };
      Api().addIssue(data).then(
        (value) {
          isLoading.value = false;
          if (value?.status ?? false) {
            CustomWidgets.showToast("Delete request sent successfully");
            Get.offAll(() => LoginScreen());
          } else {
            CustomWidgets.showToast("Failed to send delete request");
          }
        },
      );
    } else {
      CustomWidgets.showSnackBar('Invalid', 'Please specify reason to delete account.(Min 20 characters)');
    }
  }

  void showPassword() => isObscure.value = false;
  void hidePassword() => isObscure.value = true;

  void showOldPassword() => isOldPassObscure.value = false;
  void hideOldPassword() => isOldPassObscure.value = true;

  void showNewPassword() => isNewPassObscure.value = false;
  void hideNewPassword() => isNewPassObscure.value = true;

  void showConfirmPassword() => isConfirmPassObscure.value = false;
  void hideConfirmPassword() => isConfirmPassObscure.value = true;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }
}
