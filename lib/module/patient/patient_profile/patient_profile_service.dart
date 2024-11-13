import 'package:hdccapp/config/user_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/server_config.dart';
import '../../../models/appointment_by_status_model.dart';

class AppointmentService {
  final String baseUrl;

  AppointmentService({required this.baseUrl});

  Future<List<AppointmentByStatus>> fetchAppointmentsByStatus(String status, int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl${ServerConfig.appointmentBYStatus(userId, status)}'));
      print('API Response: ${response.body}');
      print('Status Code: ${response.statusCode}');
      print('User ID: ${Userinformation.id}');

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => AppointmentByStatus.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching appointments: $e');
      throw Exception('Failed to load appointments: $e');
    }
  }
}
