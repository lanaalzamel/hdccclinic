import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../models/user.dart';

class ResetPasswordService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.resetpasswordcode);
  var message;
  Future<bool> register(User1 user) async {
    var body = {
      'password': user.password,
      'password_confirmation': user.resetpassword
    };
    print('Request Body: $body');
    var response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: body,
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      message = 'resetpassword succssfully';
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
