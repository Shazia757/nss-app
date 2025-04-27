import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/issues_model.dart';

class IssuesController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  RxString submittedTo = 'sec'.obs;
  RxBool isLoading = true.obs;
  late TabController tabController;
  RxList<Issues> openedList = <Issues>[].obs;
  RxList<Issues> closedList = <Issues>[].obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    (LocalStorage().readUser().role != 'vol')
        ? getAdminIssues()
        : getVolIssues();
    super.onInit();
  }

  getAdminIssues() {
    isLoading.value = true;
    Api().getAdminIssues(LocalStorage().readUser().role!).then(
      (value) {
        openedList.assignAll(value?.openIssues ?? []);
        closedList.assignAll(value?.closedIssues ?? []);
        isLoading.value = false;
        log("${value?.openIssues} Open List Admin");
        log("${value?.closedIssues} closed List Admin");
      },
    );
  }

  void getVolIssues() {
    isLoading.value = true;
    Api().getVolIssues(LocalStorage().readUser().role!).then(
      (value) {
        openedList.assignAll(value?.openIssues ?? []);
        closedList.assignAll(value?.closedIssues ?? []);
        log("${value?.openIssues} Open List Vol");
        log("${value?.closedIssues} closed List Vol");
        isLoading.value = false;
      },
    );
  }

  void reportIssue() {
    Api()
        .addIssue(Issues(
      subject: subjectController.text,
      description: desController.text,
      to: toController.text,
      createdBy: LocalStorage().readUser().admissionNo,
    ))
        .then(
      (value) {
        if (value?.status ?? false == true) {
          subjectController.clear();
          desController.clear();
          Get.snackbar(
              "Success", value?.message ?? "Issue reported successfully");
          Get.back();
        } else {
          Get.snackbar("Error", value?.message ?? 'Failed to report issue.');
        }
      },
    );
  }

  void resolveIssue() {
    Api().addIssue(Issues(isOpen: false));
  }

  bool onSubmitIssueValidation() {
    if (subjectController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please enter subject');
      return false;
    }

    if (desController.text.isEmpty) {
      Get.snackbar('Invalid', 'Please add description');
      return false;
    }
    return true;
  }
}
