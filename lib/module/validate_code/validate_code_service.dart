import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/code.dart';

class VerifyCodeService {
  var url =
  Uri.parse(ServerConfig.domainNameServer + ServerConfig.validatecode);
  var message;
  Future<bool> VerifyCode(Code code) async {
    var response = await http.post(url,
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'code': code.code.toString(),
        });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return true;
    } else if (response.statusCode == 422) {
      var jsonResponse = jsonDecode(response.body);
      message = jsonResponse['errors'];
      return false;
    } else {
      return false;
    }
  }
}
