import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/custom_decorations.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen(
      {super.key, required this.userId, required this.isChangepassword});
  final String userId;
  final bool isChangepassword;

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());
    if (!isChangepassword) {
      c.admissionNoController.text =
          (LocalStorage().readUser().admissionNo).toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${isChangepassword ? "Change" : "Reset"} Password"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.only(
                  top: 130, bottom: 150, left: 20, right: 20),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  children: [
                    !isChangepassword
                        ? TextField(
                            readOnly: !isChangepassword,
                            controller: c.admissionNoController,
                            decoration: CustomWidgets.textFieldDecoration(
                                label: "Admission Number"),
                          )
                        : SizedBox(),
                    isChangepassword
                        ? TextField(
                            controller: c.passwordController,
                            decoration: CustomWidgets.textFieldDecoration(
                                label: "Old Password"),
                          )
                        : SizedBox(),
                    const SizedBox(height: 10),
                    TextField(
                      controller: c.newPassController,
                      decoration: CustomWidgets.textFieldDecoration(
                          label: "New Password"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: c.confirmPassController,
                      decoration: CustomWidgets.textFieldDecoration(
                          label: "Confirm New Password"),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => c.isLoading.value
                          ? CircularProgressIndicator()
                          : FilledButton(
                              style: FilledButton.styleFrom(
                                fixedSize: const Size(double.maxFinite, 48),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryFixed,
                              ),
                              onPressed: () {
                                c.isLoading.value
                                    ? CircularProgressIndicator()
                                    : c.changePassword(userId);
                              },
                              child: Text(
                                  "${isChangepassword ? "Change" : "Reset"} Password"),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
