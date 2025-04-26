import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/home_screen.dart';

class AccountController extends GetxController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController admissionNoController = TextEditingController();
  String email = '';
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
    isLoading.value = true;
    errorMessage.value = '';

    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      errorMessage.value = 'Please fill all fields!';
      Get.snackbar('Error', 'Please fill all fields!');
      return;
    }

    api.login({'admission_number': userName, 'password': password}).then(
      (response) async {
        if (response?.status == true && response?.data.admissionNo != null) {
          await LocalStorage().writeUser(response?.data??Users());
          Get.snackbar('Welcome', '${response?.data.name}');
          Get.offAll(() => HomeScreen());
        } else {
          errorMessage.value =
              response?.message ?? 'Invalid username or password!';
          Get.snackbar('Error', errorMessage.value);
        }
        isLoading.value = false;
      },
    );
  }
}
