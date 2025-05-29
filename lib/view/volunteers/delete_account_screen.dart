import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/view/authentication/login_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});

  final AccountController c = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Text(
            "Select a reason to delete this account:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            leading: Obx(() => RadioListTile.adaptive(
                  value: 'No longer needed',
                  groupValue: c.reason.value,
                  onChanged: (value) {
                    c.reason.value = value ?? 'No longer needed';
                  },
                  title: Text('No longer needed'),
                )),
          ),
          ListTile(
            leading: Obx(() => RadioListTile.adaptive(
                  value: 'Other',
                  groupValue: c.reason.value,
                  onChanged: (value) {
                    c.reason.value = value ?? 'NA';
                  },
                  title: Text('Other'),
                )),
          ),
          Obx(() => Visibility(
                visible: (c.reason.value == 'Other'),
                child: CustomWidgets().textField(
                    controller: c.reasonController,
                    label: '',
                    hintText: 'Please specify the reason here',
                    maxlines: 8,
                    margin: EdgeInsets.symmetric(horizontal: 10)),
              )),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => CustomWidgets().showConfirmationDialog(
                title: "Delete Account",
                message: "Are you sure you want to delete this account?",
                onConfirm: () => Get.offAll(() => LoginScreen()),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.error,
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: Text("Delete Account",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
