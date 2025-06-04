import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/authentication/delete_account_screen.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:url_launcher/url_launcher.dart';

import 'change_password_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalStorage().readUser();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: theme.colorScheme.onPrimaryContainer,
        foregroundColor: theme.colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        Text("Department: ${user.department ?? "N/A"}",
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          CustomWidgets().buildActionButton(
            context: context,
            icon: Icons.password,
            text: "Change Password",
            color: theme.primaryColor,
            onPressed: () => Get.to(() => ChangePasswordScreen(
                  isChangepassword: true,
                  userId: user.admissionNo ?? "",
                )),
          ),
          CustomWidgets().buildActionButton(
            context: context,
            icon: Icons.logout,
            text: "Logout",
            color: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () => CustomWidgets().showConfirmationDialog(
                title: 'Logout',
                message: 'Are you sure you want to logout?',
                onConfirm: () {
                  LocalStorage().clearAll();
                  Get.offAll(() => LoginScreen());
                },
              ),
          ),
          CustomWidgets().buildActionButton(
            context: context,
            icon: Icons.delete,
            text: "Delete Account",
            color: theme.colorScheme.error,
            onPressed: () => Get.to(() => DeleteAccountScreen()),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegalLink(context,
                  title: 'Privacy Policy',
                  baseUrl: "nssapi.bvocfarookcollege.com",
                  path: '/pricay_policy'),
              _buildLegalLink(context,
                  title: 'Terms & Conditions',
                  baseUrl: "nssapi.bvocfarookcollege.com",
                  path: "/terms_and_conditions"),
            ],
          ),
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Version 0.0.1',
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLink(BuildContext context,
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
            color: Theme.of(context).colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
