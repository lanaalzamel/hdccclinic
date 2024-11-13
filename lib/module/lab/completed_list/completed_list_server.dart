import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/server_config.dart';
import '../../../models/update_request_model.dart';
import '../../../models/updated_request_model.dart';

class UpdateRequestServer {
  Future<List<UpdateRequest>> fetchLabRequests(int labId) async {
    final url = ServerConfig.domainNameServer + ServerConfig.showUpdatedRequest(labId);
    print('Fetching lab requests from: $url');

    final response = await http.get(Uri.parse(url));
    print('Status code: ${response.statusCode}');
    print('ffffffffffffffffffffffffffff');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      print('Parsed JSON: $responseJson');

      // Extract the list from the JSON object
      List<dynamic> labRequestsJson = responseJson['Lab_requests'];
      print('Lab requests JSON: $labRequestsJson');

      List<UpdateRequest> updateRequests = UpdateRequest.listFromJson(labRequestsJson);
      print('Update requests: $updateRequests');
      return updateRequests;
    } else {
      print('Failed to load lab requests with status code: ${response.statusCode}');
      throw Exception('Failed to load lab requests');
    }
  }
}
