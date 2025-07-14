import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/config/urls.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/authentication/delete_account_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());
    final user = LocalStorage().readUser();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        foregroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            (user.name ?? "N")[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name ?? "N/A",
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text("Admission No: ${user.admissionNo ?? "N/A"}",
                                  style: theme.textTheme.bodySmall),
                              Text(
                                  "Department: ${user.department?.category} ${user.department?.name}",
                                  style: theme.textTheme.bodySmall),
                              Text("Role: ${user.role ?? "N/A"}",
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                buildActionButton(
                  icon: Icons.lock,
                  text: "Change Password",
                  onPressed: () => Get.to(() => ChangePasswordScreen(
                        isChangepassword: true,
                        userId: user.admissionNo ?? "",
                      )),
                ),
                buildActionButton(
                  icon: Icons.logout,
                  text: "Logout",
                  onPressed: () => CustomWidgets().showConfirmationDialog(
                      title: 'Logout',
                      message: 'Are you sure you want to logout?',
                      onConfirm: () => c.logout(),
                      data: Obx(
                        () => (c.isLoading.value)
                            ? CircularProgressIndicator()
                            : Text("Confirm",
                                style: TextStyle(color: Colors.red)),
                      )),
                ),
                buildActionButton(
                  icon: Icons.delete_outline,
                  iconColor: Colors.red.shade600,
                  text: "Delete Account",
                  onPressed: () => Get.to(() => DeleteAccountScreen()),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact Us",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blueGrey.shade700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: Details.contactNo1);
                              await launchUrl(
                                phoneUri,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            label: Text(
                              "Dr.Mansoor Ali T",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 13),
                            ),
                            icon: Icon(
                              Icons.call,
                              color: Colors.grey.shade800,
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.zero),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: Details.contactNo2);
                              await launchUrl(
                                phoneUri,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                            label: Text(
                              "Dr.Vahida Beegam",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 13),
                            ),
                            icon: Icon(
                              Icons.call,
                              color: Colors.grey.shade800,
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.zero),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final Uri emailUri = Uri(
                                  scheme: 'mailto', path: Details.contactEmail);
                              await launchUrl(emailUri,
                                  mode: LaunchMode.externalApplication);
                            },
                            label: Text(
                              Details.contactEmail,
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 13),
                            ),
                            icon: Icon(
                              Icons.email_outlined,
                              color: Colors.grey.shade800,
                            ),
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size.zero),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _urlLaunch(context,
                        title: 'Privacy Policy',
                        baseUrl: "nss.noorabiyad.com",
                        path: '/privacy-policy'),
                    _urlLaunch(context,
                        title: 'Terms & Conditions',
                        baseUrl: "nss.noorabiyad.com",
                        path: "/terms-and-conditions"),
                  ],
                ),
                SizedBox(height: 10),
                CustomWidgets().footer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _urlLaunch(BuildContext context,
      {required String title, required String baseUrl, String path = ''}) {
    return InkWell(
      onTap: () async {
        try {
          await launchUrl(Uri.http(
            baseUrl, // authority (host)
            path, // path
          ));
        } catch (e) {
          log(e.toString());
          Get.snackbar("Error", "Unable to open link",
              snackPosition: SnackPosition.BOTTOM);
        }
      },
      child: Text(
        title,
        style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildActionButton(
      {IconData? icon,
      required String text,
      required VoidCallback onPressed,
      Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            radius: 16,
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          title: Text(text,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          onTap: onPressed,
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
