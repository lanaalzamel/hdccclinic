import 'package:get/get.dart';
import 'package:hdccapp/module/lab/lab_home/home_lab_server.dart';

import '../../../config/user_info.dart';
import '../../../models/show_lab_request.dart';

class LabRequestController extends GetxController {
  var labRequests = <LabRequest>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initUserAndFetchLabRequests();
  }

  Future<void> initUserAndFetchLabRequests() async {
    try {
      await Userinformation.fetchUserIdFromSecureStorage();
      fetchLabRequests(Userinformation.id);
      print(Userinformation.id);
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  Future<void> fetchLabRequests(int labId) async {
    try {
      isLoading(true);
      var requests = await LabRequestService().fetchLabRequests(labId);
      if (requests.isNotEmpty) {
        labRequests.value = requests;
      } else {
        labRequests.clear();
      }
    } finally {
      isLoading(false);
    }
  }
}
