import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Why do you want to delete your account?",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: c.reasonController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: "Please specify your reason here...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomWidgets().buildActionButton(
                  context: context,
                  onPressed: () => (c.reasonController.text.isNotEmpty)
                      ? CustomWidgets().showConfirmationDialog(
                          title: "Do you want to delete?",
                          content: Text(
                            "This will send request to the admin to delete your account. After approving, all your data will be lost and cannot login again.",
                          ),
                          onConfirm: () => c.deleteAccount(),
                          data: Obx(
                            () => (c.isLoading.value)
                                ? CircularProgressIndicator()
                                : Text('Confirm'),
                          ))
                      : CustomWidgets.showToast('Please specify the reason'),
                  text: "Delete Account",
                  icon: Icons.delete,
                  color: const Color.fromARGB(255, 158, 13, 3)),
            )
          ],
        ),
      ),
    );
  }
}
