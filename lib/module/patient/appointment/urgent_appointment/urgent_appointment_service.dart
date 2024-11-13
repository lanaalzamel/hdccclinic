import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../config/server_config.dart';
import '../../../../models/emergency_response .dart';
import '../../../../models/urgent_appointment_model.dart';


class UrgentAppointmentService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.urgentappointment);
  var message;

  Future<EmergencyResponse?> sendEmergency(Emergency emergency) async {
    var body = emergency.toJson();
    print('Request Body: $body');

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200|| response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      message = 'Emergency reported successfully';
      return EmergencyResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 422) {
      var jsonResponse = jsonDecode(response.body);
      message = jsonResponse['errors'];
      return null;
    } else {
      return null;
    }
  }
}
