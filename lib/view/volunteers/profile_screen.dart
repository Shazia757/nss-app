import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/volunteer_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/users_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/custom_decorations.dart';
import 'package:nss/view/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.isUpdateScreen, this.user});
  final bool? isUpdateScreen;
  final Users? user;

  @override
  Widget build(BuildContext context) {
    final isProfilePage = (isUpdateScreen == null);
    VolunteerController c = Get.put(VolunteerController());

    if (isUpdateScreen ?? false) {
      c.setUpdateData(user!);
    } else {
      c.clearTextFields();
    }

    if (isProfilePage) c.setUpdateData(LocalStorage().readUser());

    return Scaffold(
      bottomNavigationBar: isProfilePage ? CustomNavBar(currentIndex: 2) : null,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          isProfilePage
              ? "Profile"
              : isUpdateScreen!
                  ? "Update Volunteer"
                  : "Add Volunteer",
        ),
        actions: [
          Visibility(
            visible: isProfilePage,
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Get.to(() => LoginScreen());
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16),
        child: ListView(
          children: [
            if (isProfilePage) ...[
              Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    (LocalStorage().readUser().name ?? "N")[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
            _buildTextField(c.nameController, "Name", isProfilePage),
            _buildTextField(c.emailController, "Email", isProfilePage,
                margin: EdgeInsets.symmetric(vertical: 10)),
            _buildTextField(c.phoneController, "Phone", isProfilePage),
            _buildTextField(c.depController, "Department", isProfilePage,
                margin: EdgeInsets.symmetric(vertical: 10)),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        c.rollNoController, "Roll No", isProfilePage,
                        keyboardType: TextInputType.number)),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                    c.admissionNoController,
                    "Admission No",
                    isProfilePage,
                    keyboardType: TextInputType.number,
                    isEnabled: !(isUpdateScreen == true),
                  ),
                ),
              ],
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: CustomWidgets().datePickerTextField(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  context: context,
                  controller: c.dobController,
                  disableTap: isProfilePage,
                  label: "Date of Birth",
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now().subtract(Duration(days: 365 * 10)),
                  selectedDate: (value) => c.dob = value,
                  decoration: InputDecoration(
                    label: Text("Date Of Birth"),
                    border: InputBorder.none,
                    labelStyle: TextStyle(fontSize: 14),
                  )),
            ),
            SizedBox(height: 20),
            if (!isProfilePage) ...[
              _buildActionButton(
                  context: context,
                  text:
                      "${isUpdateScreen ?? false ? "Update" : "Add"} Volunteer",
                  icon: Icons.add,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (c.onSubmitVolValidation()) {
                      if (isUpdateScreen ?? false) {
                        _showConfirmationDialog(context, "Update Volunteer",
                            "Are you sure you want to update the details?", () {
                          c.updateVolunteer();
                        });
                      } else {
                        c.addVolunteer();
                      }
                    }
                  }),
              SizedBox(height: 15),
            ],
            if (isUpdateScreen ?? false)
              _buildActionButton(
                context: context,
                text: "Delete Volunteer",
                icon: Icons.delete,
                color: Theme.of(context).colorScheme.error,
                onPressed: () => _showConfirmationDialog(
                  context,
                  "Delete Volunteer",
                  "Are you sure you want to delete this volunteer?",
                  () => c.deleteVolunteer(),
                ),
              ),
            SizedBox(height: 15),
            if (isUpdateScreen == true || isProfilePage)
              _buildActionButton(
                context: context,
                text: "Change Password",
                icon: Icons.password,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  // Get.to(() => ChangePasswordScreen(
                  //     userId: c.admissionNoController.text));
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isProfilePage,
      {EdgeInsets margin = EdgeInsets.zero,
      TextInputType? keyboardType,
      bool isEnabled = true}) {
    return Padding(
      padding: margin,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            readOnly: isProfilePage,
            enabled: isEnabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              border: InputBorder.none,
              labelStyle: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required BuildContext context,
      required String text,
      required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
            TextButton(
              onPressed: () {
                onConfirm();
                Get.back();
              },
              child: Text("Confirm", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
