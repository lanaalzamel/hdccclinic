import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hdccapp/models/today_request_model.dart';
import 'package:hdccapp/module/lab/lab_home/new_lab_request_list/new_lab_request_list_server.dart';
import '../../../../config/user_info.dart';

class TodayLabRequestListController extends GetxController {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  var labRequests = <TodayRequest>[].obs;
  var isLoading = true.obs;
  var openedRequestIds = <int>[].obs; // IDs of opened requests
  var newRequestIds = <int>[].obs; // IDs of new (unopened) requests

  @override
  void onInit() {
    super.onInit();
    initUserAndFetchTodayLabRequests();
  }

  Future<void> initUserAndFetchTodayLabRequests() async {
    try {
      await Userinformation.fetchUserIdFromSecureStorage();
      await loadOpenedRequestIds(); // Load opened request IDs from secure storage
      await fetchLabRequests(Userinformation.id); // Fetch lab requests after loading opened IDs
      print("User ID: ${Userinformation.id}");
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  Future<void> fetchLabRequests(int labId) async {
    try {
      isLoading(true);
      var requests = await todayLabRequestListServer().fetchLabRequests(labId);
      if (requests.isNotEmpty) {
        labRequests.value = requests;
        _updateNewRequestIds(requests);
      } else {
        labRequests.clear();
        newRequestIds.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  void _updateNewRequestIds(List<TodayRequest> requests) {
    // Clear previous newRequestIds
    newRequestIds.clear();

    // Determine new requests by excluding openedRequestIds
    for (var request in requests) {
      if (!openedRequestIds.contains(request.id)) {
        newRequestIds.add(request.id);
      }
    }
  }

  Future<void> markRequestAsOpened(int requestId) async {
    if (newRequestIds.contains(requestId)) {
      newRequestIds.remove(requestId);
      openedRequestIds.add(requestId);
      await saveOpenedRequestIds(); // Persist opened request IDs
      update(); // Refresh UI
    }
  }

// In loadOpenedRequestIds()
  Future<void> loadOpenedRequestIds() async {
    String? storedIds = await _secureStorage.read(key: 'openedRequestIds');
    if (storedIds != null && storedIds.isNotEmpty) {
      try {
        openedRequestIds.value =
            storedIds.split(',').map((e) => int.parse(e)).toList();
        print("Loaded opened request IDs: ${openedRequestIds}");
      } catch (e) {
        print("Error parsing opened request IDs: $e");
        openedRequestIds.clear();
      }
    } else {
      print("No opened request IDs found.");
    }
  }


  // Save opened request IDs to secure storage
  Future<void> saveOpenedRequestIds() async {
    String idsToSave = openedRequestIds.join(',');
    await _secureStorage.write(key: 'openedRequestIds', value: idsToSave);
    print("Saved opened request IDs: $idsToSave");
  }
}
