import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/server_config.dart';

class SplashService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.check_valid);
  var message;
  var userType;

  Future<bool> checkValid(String token) async {
    print('Token passed to checkValid: $token');
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response splash status: ${response.statusCode}');
    print(response.body);
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      userType = responseBody['user_type'];
      return true;
    } else if (response.statusCode == 402) {
      message = 'Session Expired';
      return false;
    } else {
      message = 'Server error';
      return false;
    }
  }
}
