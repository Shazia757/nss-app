import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/view/custom_decorations.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen(
      {super.key, required this.userId, required this.isChangepassword});
  final String userId;
  final bool? isChangepassword;

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${isChangepassword ?? false ? "Change" : "Reset"} Password"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Card(
          margin:
              const EdgeInsets.only(top: 150, bottom: 150, left: 20, right: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: ListView(
              children: [
                isChangepassword == false
                    ? TextField(
                        autofocus: true,
                        readOnly: isChangepassword == false,
                        controller: c.admissionNoController,
                        decoration: CustomWidgets.textFieldDecoration(
                            prefix: Text(c.admissionNoController.text),
                            label: "Admission Number"),
                      )
                    : SizedBox(),
                const SizedBox(height: 10),
                TextField(
                  controller: c.newPassController,
                  decoration:
                      CustomWidgets.textFieldDecoration(label: "New Password"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: c.confirmPassController,
                  decoration: CustomWidgets.textFieldDecoration(
                      label: "Confirm New Password"),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(double.maxFinite, 48),
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                  onPressed: () {
                    c.changePassword(userId);
                  },
                  child: Text(
                      "${isChangepassword ?? false ? "Change" : "Reset"} Password"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
