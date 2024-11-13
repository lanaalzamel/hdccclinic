import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../config/server_config.dart';
import '../../../../models/today_request_model.dart';


class todayLabRequestListServer {
  Future<List<TodayRequest>> fetchLabRequests(int labId) async {
    final url = ServerConfig.domainNameServer +
        ServerConfig.showTodayRequests(labId);

    print(url);
    print(labId);

    final response = await http.get(Uri.parse(url));
    print('newwwwwwwwwwwww');
    print('today requests: ${response.body}');
    print(response.statusCode);
    print('newwwwwwwwwwwww');
    if (response.statusCode == 200) {
      List<dynamic> labRequestsJson = jsonDecode(response.body);
      List<TodayRequest> labRequests = TodayRequest.listFromJson(labRequestsJson);
      return labRequests;
    } else {
      throw Exception('Failed to load lab requests');
    }
  }
}
