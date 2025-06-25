import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/model/programs_model.dart';
import 'package:nss/model/volunteer_model.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class HomeController extends GetxController {
  RxList<Program> upcomingPrograms = <Program>[].obs;
  final api = Api();
  RxBool isLoading = true.obs;
  // RxList<Volunteer> studentsEnrolled = <Volunteer>[].obs;

  @override
  void onInit() {
    fetchUpcomingPrograms();
    super.onInit();
  }

  void fetchUpcomingPrograms() async {
    isLoading.value = true;
    upcomingPrograms.clear();
    api.getUpcomingPrograms().then(
      (value) {
        upcomingPrograms.assignAll(value?.programs ?? []);
        upcomingPrograms.sort((a, b) => b.date!.compareTo(a.date!));
        isLoading.value = false;
      },
    );
  }

  // void addParticipant(Program program) async {
  //   isLoading.value = true;
  //   api.addParticipant({
  //     'admission_number': (LocalStorage().readUser().admissionNo),
  //     'name': (LocalStorage().readUser().name),
  //     'department': (LocalStorage().readUser().department),
  //     'program': program.name
  //   }).then(
  //     (response) {
  //       isLoading.value = false;
  //       Get.back();
  //       if (response?.status == true) {
  //         Get.back();
  //         CustomWidgets.showSnackBar(
  //             'Success', response?.message ?? 'You are enrolled.');
  //       } else {
  //         CustomWidgets.showSnackBar(
  //             'Error', response?.message ?? 'Failed to enroll.');
  //       }
  //     },
  //   );
  // }
}
