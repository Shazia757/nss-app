import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen(
      {super.key, required this.userId, required this.isChangepassword});
  final String userId;
  final bool isChangepassword;

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());

    return Scaffold(
      appBar: AppBar(
        title: Text("${isChangepassword ? "Change" : "Reset"} Password"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: ListView(
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
                        ? Text(
                            userId,
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer),
                          )
                        : SizedBox(),
                    if (isChangepassword)
                      Obx(
                        () => SizedBox(
                          height: 50,
                          child: CustomWidgets().textField(
                            margin: EdgeInsets.symmetric(vertical: 0),
                            controller: c.oldpasswordController,
                            hideText: c.isOldPassObscure.value,
                            label: "Old Password",
                            suffix: GestureDetector(
                              onTap: () => (c.isOldPassObscure.value)
                                  ? c.showOldPassword()
                                  : c.hideOldPassword(),
                              child: Icon(
                                c.isOldPassObscure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(),
                    const SizedBox(height: 10),
                    Obx(
                      () => SizedBox(
                        height: 50,
                        child: CustomWidgets().textField(
                          margin: EdgeInsets.symmetric(vertical: 0),
                          controller: c.newPassController,
                          hideText: c.isNewPassObscure.value,
                          label: "New Password",
                          suffix: GestureDetector(
                            onTap: () => c.isNewPassObscure.value
                                ? c.showNewPassword()
                                : c.hideNewPassword(),
                            child: Icon(
                              c.isNewPassObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => SizedBox(
                        height: 50,
                        child: CustomWidgets().textField(
                          controller: c.confirmPassController,
                          hideText: c.isConfirmPassObscure.value,
                          label: "Confirm new Password",
                          margin: EdgeInsets.symmetric(vertical: 0),
                          suffix: GestureDetector(
                            onTap: () => (c.isConfirmPassObscure.value)
                                ? c.showConfirmPassword()
                                : c.hideConfirmPassword(),
                            child: Icon(
                              c.isConfirmPassObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isChangepassword
                        ? CustomWidgets().buildActionButton(
                            context: context,
                            text: "Change Password",
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                            onPressed: () {
                              if (c.onChangePassValidation()) {
                                CustomWidgets().showConfirmationDialog(
                                    title: "Change Password",
                                    message:
                                        "Are you sure you want to change your password?",
                                    onConfirm: () => c.changePassword(userId),
                                    data: Obx(
                                      () => (c.isLoading.value)
                                          ? CircularProgressIndicator()
                                          : Text('Confirm'),
                                    ));
                              }
                            })
                        : CustomWidgets().buildActionButton(
                            context: context,
                            text: "Reset Password",
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                            onPressed: () {
                              if (c.onResetPassValidation()) {
                                CustomWidgets().showConfirmationDialog(
                                    title: "Reset Password",
                                    message:
                                        "Are you sure you want to reset the password?",
                                    onConfirm: () => c.resetPassword(userId),
                                    data: Obx(
                                      () => (c.isLoading.value)
                                          ? CircularProgressIndicator()
                                          : Text('Confirm'),
                                    ));
                              }
                            }),
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
