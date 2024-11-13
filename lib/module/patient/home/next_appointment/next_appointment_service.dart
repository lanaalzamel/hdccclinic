import 'package:hdccapp/config/server_config.dart';
import 'package:hdccapp/config/user_info.dart';
import 'package:hdccapp/models/next_appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NextAppointmentService {
  Future<NextAppointment> getNextAppointment(String token) async {
    // Ensure that Userinformation.id is set correctly before calling this method
    if (Userinformation.id == -1) {
      try {
        await Userinformation.fetchUserIdFromSecureStorage();
      } catch (e) {
        throw Exception('Failed to fetch user ID: $e');
      }
    }

    // Construct the URL for fetching the next appointment
    final url = ServerConfig.domainNameServer +
        ServerConfig.nextAppointment(Userinformation.id);
    print(url);
    print('Id: ${Userinformation.id}');
    try {
      // Make the HTTP GET request with the appropriate headers
      var response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      print(response.statusCode);
      print(response.body);
      // Check the status code of the response
      if (response.statusCode == 200) {
        // If successful, parse the JSON response and return the NextAppointment object
        final data = json.decode(response.body);
        print('''''''''''''''''''''''''''''');
        print('Response data: $data');
        print('''''''''''''''''''''''''''''');
        return NextAppointment.fromJson(data);
      } else {
        // If the request fails, throw an exception with an appropriate message
        throw Exception('Failed to load appointment: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any exceptions that occur during the process and rethrow them
      throw Exception('Failed to load appointment: $e');
    }
  }
}
