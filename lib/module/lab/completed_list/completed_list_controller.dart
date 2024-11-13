import 'package:get/get.dart';
import '../../../../config/user_info.dart';
import '../../../models/update_request_model.dart';
import '../../../models/updated_request_model.dart';
import 'completed_list_server.dart';


class UpdatedRequestController extends GetxController {
  var updateRequests = <UpdateRequest>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    print("Controller initialized"); // Ensure this is printed
    initUserAndFetchUpdatedLabRequests();
  }
  Future<void> initUserAndFetchUpdatedLabRequests() async {
    try {
      await Userinformation.fetchUserIdFromSecureStorage();
      print('Fetched user ID: ${Userinformation.id}');
      fetchUpdateRequests(Userinformation.id);
    } catch (e) {
      print("Error fetching user ID: $e");
      isLoading(false);  // Stop loading if there's an error
    }
  }

  Future<void> fetchUpdateRequests(int labId) async {
    print('test');
    try {
      isLoading(true);
      print('Fetching update requests for lab ID: $labId');
      var requests = await UpdateRequestServer().fetchLabRequests(labId);
      if (requests.isNotEmpty) {
        updateRequests.value = requests;
        print('Update requests fetched: ${updateRequests.length}');
      } else {
        updateRequests.clear();
        print('No update requests found');
      }
    } catch (e) {
      print('Error fetching update requests: $e');
    } finally {
      isLoading(false);
    }
  }
}
