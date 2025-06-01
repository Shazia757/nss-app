import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/view/authentication/change_password_screen.dart';
import 'package:nss/controller/volunteer_controller.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/authentication/settings.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';
import 'package:nss/view/authentication/login_screen.dart';
import 'package:nss/view/authentication/delete_account_screen.dart';

class VolunteerAddScreen extends StatelessWidget {
  const VolunteerAddScreen({super.key, this.isUpdateScreen, this.user});
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
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () => Get.to(() => SettingsScreen()),
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
            CustomWidgets().textField(
              controller: c.nameController,
              label: "Name",
              readOnly: isProfilePage,
            ),
            CustomWidgets().textField(controller: c.emailController, label: "Email", readOnly: isProfilePage, margin: EdgeInsets.symmetric(vertical: 10)),
            CustomWidgets().textField(controller: c.phoneController, label: "Phone", readOnly: isProfilePage),
            CustomWidgets().textField(controller: c.depController, label: "Department", readOnly: isProfilePage, margin: EdgeInsets.symmetric(vertical: 5)),
            CustomWidgets().textField(controller: c.yearController, label: "Year of Study", readOnly: isProfilePage, keyboardType: TextInputType.number),
            Row(
              children: [
                Expanded(child: CustomWidgets().textField(controller: c.rollNoController, label: "Roll No", readOnly: isProfilePage, keyboardType: TextInputType.number)),
                SizedBox(width: 10),
                Expanded(child: CustomWidgets().textField(controller: c.admissionNoController, label: "Admission No", keyboardType: TextInputType.number, isEnabled: !(isUpdateScreen ?? false), readOnly: isProfilePage)),
              ],
            ),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: CustomWidgets().datePickerTextField(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  context: context,
                  controller: c.dobController,
                  disableTap: isProfilePage,
                  label: "Date of Birth",
                  initialDate: c.dob,
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
            ((!isProfilePage) && (LocalStorage().readUser().role == 'po'))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Promote As Secretary',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Obx(() => Switch(
                          value: c.role.value == 'sec',
                          onChanged: (value) {
                            if (value) {
                              c.role.value = 'sec';
                            } else {
                              c.role.value = 'vol';
                            }
                          })),
                    ],
                  )
                : SizedBox(),
            if (!isProfilePage) ...[
              Obx(
                () => c.isUpdateButtonLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : AbsorbPointer(
                        absorbing: c.isUpdateButtonLoading.value || c.isDeleteButtonLoading.value,
                        child: CustomWidgets().buildActionButton(
                            context: context,
                            text: "${isUpdateScreen ?? false ? "Update" : "Add"} Volunteer",
                            icon: Icons.add,
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (c.onSubmitVolValidation()) {
                                if (isUpdateScreen ?? false) {
                                  CustomWidgets().showConfirmationDialog(
                                      title: "Update Volunteer",
                                      message: "Are you sure you want to update the details?",
                                      onConfirm: () {
                                        c.updateVolunteer();
                                      });
                                } else {
                                  CustomWidgets().showConfirmationDialog(
                                      title: "Add Volunteer",
                                      message: "Are you sure you want to add new volunteer?",
                                      onConfirm: () {
                                        c.addVolunteer();
                                      });
                                }
                              }
                            }),
                      ),
              ),
              SizedBox(height: 15),
            ],
            if (isUpdateScreen ?? false)
              Obx(
                () => c.isDeleteButtonLoading.value
                    ? Center(child: CircularProgressIndicator())
                    : AbsorbPointer(
                        absorbing: c.isDeleteButtonLoading.value || c.isUpdateButtonLoading.value,
                        child: CustomWidgets().buildActionButton(
                          context: context,
                          text: "Delete Volunteer",
                          icon: Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                          onPressed: () => CustomWidgets().showConfirmationDialog(
                            title: "Delete Volunteer",
                            message: "Are you sure you want to delete this volunteer?",
                            onConfirm: () => c.deleteVolunteer(),
                          ),
                        ),
                      ),
              ),
            SizedBox(height: 15),
            if (isUpdateScreen == true)
              CustomWidgets().buildActionButton(
                  context: context,
                  text: "Reset Password",
                  icon: Icons.password,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Get.to(() => ChangePasswordScreen(isChangepassword: false, userId: c.admissionNoController.text));
                  }),
          ],
        ),
      ),
    );
  }

  // Widget _buildActionButton(
  //     {required BuildContext context,
  //     required String text,
  //     required IconData icon,
  //     required Color color,
  //     required VoidCallback onPressed}) {
  //   return ElevatedButton.icon(
  //     onPressed: onPressed,
  //     style: ElevatedButton.styleFrom(
  //       foregroundColor: Colors.white,
  //       backgroundColor: color,
  //       minimumSize: Size(double.infinity, 48),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     ),
  //     icon: Icon(
  //       icon,
  //       color: Colors.white,
  //     ),
  //     label: Text(text,
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //   );
  // }
}
