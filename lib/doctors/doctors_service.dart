import 'dart:convert';

import 'package:hdccapp/models/show_doctors.dart';

import '../config/server_config.dart';
import 'package:http/http.dart' as http;

class doctorsSrevecie {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.showdoctor);
  var message;

  Future<List<Doctors>> getDoctors() async {
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    print('doctorrrrrrrrrrrrrr');
    print(response.statusCode);
    print(response.body);
    print('doctorrrrrrrrrrrrrr');
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Doctors.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load doctor info');
    }
  }
}
