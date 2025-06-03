import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/issues_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class IssuesController extends GetxController with GetTickerProviderStateMixin {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController resolvedByController = TextEditingController();

  RxString submittedTo = 'sec'.obs;
  RxBool isLoading = false.obs;
  RxBool isReportLoading = false.obs;

  RxList<Volunteer?> adminList = <Volunteer?>[].obs;
  late TabController tabController;
  List<Issues> openedList = [];
  List<Issues> closedList = [];
  RxList<Issues> modifiedOpenedList = <Issues>[].obs;
  RxList<Issues> modifiedClosedList = <Issues>[].obs;
  RxString reportedTo = 'both'.obs;
  RxBool sortByOldest = true.obs;

  late TabController adminTabController;

  RxBool isResolved = false.obs;

  // Date? date;
  void filterByRole(String assignedTo) {
    reportedTo.value = assignedTo;

    _openFilteredTo();
    _closedFilteredTo();
  }

  void _openFilteredTo() {
    if (reportedTo.value == "all") {
      modifiedOpenedList.assignAll(openedList);
    } else {
      modifiedOpenedList.assignAll(
          openedList.where((p0) => p0.to == reportedTo.value).toList());
    }
  }

  void _closedFilteredTo() {
    if (reportedTo.value == "all") {
      modifiedClosedList.assignAll(closedList);
    } else {
      modifiedClosedList.assignAll(
          closedList.where((p0) => p0.to == reportedTo.value).toList());
    }
  }

  void resolvedBy(String? admNo) {
    modifiedClosedList
        .assignAll(closedList.where((p0) => p0.updatedBy == admNo).toList());
  }

  void sortByOldestDate(bool isOldest) {
    sortByOldest.value = isOldest;
    _sortOpenedList();
    _sortClosedList();
  }

  void _sortOpenedList() {
    if (sortByOldest.isTrue) {
      modifiedOpenedList
          .sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
    } else {
      modifiedOpenedList
          .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
    }
    log("OpenList ${modifiedOpenedList.toString()}");
  }

  void _sortClosedList() {
    if (sortByOldest.isTrue) {
      modifiedClosedList
          .sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
    } else {
      modifiedClosedList
          .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
    }

    log("Closed data : ${modifiedClosedList.toString()}");
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    adminTabController = TabController(length: 2, vsync: this);
    getAdmins();
    if (LocalStorage().readUser().role != 'vol') {
      getAdminIssues();
    } else {
      getVolIssues();
    }

    super.onInit();
  }

  getAdmins() {
    Api().getAdmins().then(
      (value) {
        adminList.assignAll(value?.data ?? []);
      },
    );
  }

  getAdminIssues() {
    isLoading.value = true;
    Api().getAdminIssues(LocalStorage().readUser().role!).then(
      (value) {
        openedList = value?.openIssues ?? [];
        closedList = value?.closedIssues ?? [];
        modifiedOpenedList.assignAll(openedList);
        modifiedClosedList.assignAll(closedList);
        modifiedOpenedList
            .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        modifiedClosedList
            .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));

        isLoading.value = false;
      },
    );
  }

  void getVolIssues() {
    isLoading.value = true;

    Api().getVolIssues(LocalStorage().readUser().admissionNo!).then(
      (value) {
        openedList = value?.openIssues ?? [];
        closedList = value?.closedIssues ?? [];
        modifiedOpenedList.assignAll(openedList);
        modifiedClosedList.assignAll(closedList);
        modifiedOpenedList
            .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        modifiedClosedList
            .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));

        isLoading.value = false;
      },
    );
  }

  void reportIssue() {
    isReportLoading.value = true;
    Api().addIssue({
      'subject': subjectController.text,
      'description': desController.text,
      'assigned_to': submittedTo.value,
      'created_by': (LocalStorage().readUser().admissionNo).toString(),
      'updated_by': (LocalStorage().readUser().admissionNo).toString()
    }).then(
      (value) {
        isReportLoading.value = false;
        if (value?.status ?? false) {
          subjectController.clear();
          desController.clear();
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Issue reported successfully");
        } else {
          CustomWidgets.showSnackBar(
              "Error", value?.message ?? 'Failed to report issue.');
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
          Get.back();
          CustomWidgets.showSnackBar(
              "Success", value?.message ?? "Issue resolved successfully.");
          onInit();
        } else {
          CustomWidgets.showSnackBar(
              'Error', value?.message ?? 'Failed to resolve issue.');
        }
      },
    );
  }

  bool onSubmitIssueValidation() {
    if (subjectController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please enter subject');
      return false;
    }

    if (desController.text.isEmpty) {
      CustomWidgets.showSnackBar('Invalid', 'Please add description');
      return false;
    }
    return true;
  }

  // void sortOpenedList(Date selectedDate) {
  //   if (selectedDate == Date.oldestToLatest) {
  //     openedList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
  //   } else {
  //     openedList.sort((a, b) => b.updatedDate!.compareTo(a.updatedDate!));
  //   }
  // }

  // void sortClosedList(Date selectedDate) {
  //   if (selectedDate == Date.oldestToLatest) {
  //     closedList.sort((a, b) => a.updatedDate!.compareTo(b.updatedDate!));
  //   } else {
  //     closedList.sort((a, b) => b.updatedDate!.compareTo(a.updatedDate!));
  //   }
  // }
}
