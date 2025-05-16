import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/issues_model.dart';
import 'package:nss/view/issues/admin_issues_screen.dart';

enum Date { oldestToLatest, latestToOldest }

class IssuesController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  RxString submittedTo = 'sec'.obs;
  RxBool isLoading = true.obs;
  late TabController tabController;
  RxList<Issues> openedList = <Issues>[].obs;
  RxList<Issues> closedList = <Issues>[].obs;
  RxList<Issues> sortedopenedList = <Issues>[].obs;
  RxList<Issues> sortedclosedList = <Issues>[].obs;
  List<String> get reportedTo => ["sec", "po", "Secretary and Program Officer"];
  var selected = "both".obs;
  List<Issues> get openFilteredTo {
    if (selected.value == "both") return openedList;
    return openedList.where((p0) => p0.to == selected.value).toList();
  }

  List<Issues> get closedFilteredTo {
    if (selected.value == "both") return openedList;
    return openedList.where((p0) => p0.to == selected.value).toList();
  }

  List<String> get resolvedBy => ["sec", "sec", "sec", "sec"];
  var selectedSec = "sec".obs;
  List<Issues> get filteredResolvedBy {
    if (selected.value == "sec") return openedList;
    return closedList.where((p0) => p0.to == selected.value).toList();
  }

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
        log((value?.openIssues).toString());
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
    Api().getVolIssues(LocalStorage().readUser().admissionNo!).then(
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
    isLoading.value = true;
    Api().addIssue({
      'subject': subjectController.text,
      'description': desController.text,
      'assigned_to': submittedTo.value,
      'created_by': (LocalStorage().readUser().admissionNo).toString(),
      'updated_by': (LocalStorage().readUser().admissionNo).toString()
    }).then(
      (value) {
        isLoading.value = false;
        if (value?.status ?? false) {
          subjectController.clear();
          desController.clear();
          Get.snackbar(
              "Success", value?.message ?? "Issue reported successfully");
        } else {
          Get.snackbar("Error", value?.message ?? 'Failed to report issue.');
        }
      },
    );
  }

  void resolveIssue(int? id) {
    Api().resolveIssue(
        {'id': id, 'updated_by': LocalStorage().readUser().admissionNo}).then(
      (value) {
        if (value?.status ?? false) {
          Get.back();
          Get.snackbar(
              "Success", value?.message ?? "Issue resolved successfully.");
        } else {
          Get.snackbar('Error', value?.message ?? 'Failed to resolve issue.');
        }
      },
    );
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

  void sortOpenedList(Date selectedDate) {
    if (selectedDate == Date.oldestToLatest) {
      openedList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
    } else {
      openedList.sort((a, b) => b.updatedDate!.compareTo(a.updatedDate!));
    }
  }

  void sortClosedList(Date selectedDate) {
    if (selectedDate == Date.oldestToLatest) {
      closedList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
    } else {
      closedList.sort((a, b) => b.updatedDate!.compareTo(a.updatedDate!));
    }
  }

  void select(String to) {
    selected.value = to;
  }
}
