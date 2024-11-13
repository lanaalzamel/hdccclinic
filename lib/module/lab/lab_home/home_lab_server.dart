import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../config/server_config.dart';
import '../../../config/user_info.dart';
import '../../../models/lab_request.dart';
import '../../../models/show_lab_request.dart';

class LabRequestService {
  Future<List<LabRequest>> fetchLabRequests(int labId) async {
    final url = ServerConfig.domainNameServer +
        ServerConfig.Show_AllRequests_Sent_For_Medical_Tech_That_are_not_updated(labId);
    print(url);
    print(labId);
    final response = await http.get(Uri.parse(url));
    print('homeeeeeeeeeeeeeeeeee');
    print(response.body);
    print(response.statusCode);
    print('homeeeeeeeeeeeeeeeeee');
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> labRequestsJson = body['Lab_requests'];
      List<LabRequest> labRequests = labRequestsJson
          .map((dynamic item) => LabRequest.fromJson(item))
          .toList();
      return labRequests;
    } else {
      throw Exception('Failed to load lab requests');
    }
  }
}
