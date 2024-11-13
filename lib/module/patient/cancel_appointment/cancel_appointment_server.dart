import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/server_config.dart'; // Adjust this import as per your project structure

class CancelAppointmentService {
  Future<void> cancelAppointment(int appointmentId) async {
    var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.cancelappointment(appointmentId));
    print(url);
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
      );
print(response.body);
print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String message = jsonResponse['message'];
        // You can handle the response here, e.g., show success message
        print('Appointment canceled successfully: $message');
      } else {
        // Handle other status codes appropriately
        print('Failed to cancel appointment. Status code: ${response.statusCode}');
        throw 'Failed to cancel appointment. Status code: ${response.statusCode}';
      }
    } catch (e) {
      // Handle network errors or exceptions
      print('Error cancelling appointment: $e');
      throw 'Error cancelling appointment: $e';
    }
  }
}
