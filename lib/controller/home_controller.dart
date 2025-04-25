import 'package:get/get.dart';
import 'package:nss/api.dart';
import 'package:nss/model/programs_model.dart';

class HomeController extends GetxController {
  RxList<Program> upcomingPrograms = <Program>[].obs;
  final api = Api();
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchUpcomingPrograms();
    super.onInit();
  }

  void fetchUpcomingPrograms() async {
    isLoading.value = true;
    upcomingPrograms.clear();
    api.upcomingPrograms().then(
      (value) {
        upcomingPrograms.assignAll(value?.programs ?? []);
        isLoading.value = false;
      },
    );
  }
}
