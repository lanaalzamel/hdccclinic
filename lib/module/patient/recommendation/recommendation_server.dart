import 'dart:convert';

import 'package:hdccapp/models/show_doctors.dart';

import '../../../config/server_config.dart';
import '../../../models/recommendation_model.dart';
import 'package:http/http.dart' as http;

class RecomendationSrevecie {
  var url =
      Uri.parse(ServerConfig.domainNameServer + ServerConfig.recommendation);
  var message;

  Future<List<Recommendation>> getRecomendation(String token) async {
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('recommmmmmm');
    print(response.statusCode);
    print(response.body);
    print('recommmmmmm');
    if (response.statusCode == 200) {
      List<dynamic> recommendationsJson = jsonDecode(response.body);
      return recommendationsJson
          .map((json) => Recommendation.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }
}
