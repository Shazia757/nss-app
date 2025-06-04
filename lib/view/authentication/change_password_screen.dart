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
                              onTap: () => (c.isObscure.value)
                                  ? c.showPassword()
                                  : c.hidePassword(),
                              child: Icon(
                                c.isObscure.value
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
                            onTapDown: (_) => c.showNewPassword(),
                            onTapUp: (_) => c.hideNewPassword(),
                            onTapCancel: c.hideNewPassword,
                            child: Icon(
                              c.isObscure.value
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
                            onTapDown: (_) => c.showConfirmPassword(),
                            onTapUp: (_) => c.hideConfirmPassword(),
                            onTapCancel: c.hideConfirmPassword,
                            child: Icon(
                              c.isObscure.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => c.isLoading.value
                          ? CircularProgressIndicator()
                          : CustomWidgets().buildActionButton(
                              context: context,
                              text:
                                  "${isChangepassword ? "Change" : "Reset"} Password",
                              color:
                                  Theme.of(context).colorScheme.onPrimaryFixed,
                              onPressed: () => isChangepassword
                                  ? c.changePassword(userId)
                                  : c.resetPassword(userId),
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
