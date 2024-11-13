import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
 // Make sure to import your server config file

class LogoutService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.logout);

  Future<bool> logout(String token) async {
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
print(response.body);
print(response.statusCode);
    return response.statusCode == 200;
  }
}
