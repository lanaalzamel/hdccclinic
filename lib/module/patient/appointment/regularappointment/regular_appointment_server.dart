// book_appointment_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../config/server_config.dart';
import '../../../../config/user_info.dart';
import '../../../../models/regual_appointment.dart';

class BookAppointmentService {
  // Book an appointment
  Future<BookingResult> bookAppointment(AppointmentClass appointmentDetails) async {
    final url = ServerConfig.domainNameServer + ServerConfig.regular_appointmrnt(Userinformation.id);
    print(url);

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          "doctor_id": appointmentDetails.doctorId,
          "date": appointmentDetails.date.toIso8601String().split('T')[0],
          "time": appointmentDetails.time
        }),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var appointment = Appointment.fromJson(data);
        return BookingResult(appointment: appointment, success: true);
      } else if (response.statusCode == 400) {
        var error = jsonDecode(response.body);
        if (error.containsKey('message')) {
          return BookingResult(errorMessages: ['Failed to book appointment: ${error['message']}']);
        } else {
          return BookingResult(errorMessages: ['Failed to book appointment: Unknown error']);
        }
      } else {
        return BookingResult(errorMessages: ['Failed to book appointment: ${response.reasonPhrase}']);
      }
    } catch (e) {
      return BookingResult(errorMessages: ['Failed to book appointment: $e']);
    }
  }

  // Fetch available appointment times
  Future<List<DateTime>> fetchAvailableTimes(int doctorId, DateTime date) async {
    final url = ServerConfig.domainNameServer + ServerConfig.getavailableappointment;
    print(url);

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          "doctor_id": doctorId,
          "date": date.toIso8601String().split('T')[0],
        }),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return (data['available_times'] as List)
            .map((timeString) => DateFormat("HH:mm").parse(timeString))
            .toList();
      } else {
        throw Exception('Failed to fetch available times');
      }
    } catch (e) {
      throw Exception('Error fetching available times: $e');
    }
  }
}

class BookingResult {
  final Appointment? appointment;
  final List<String>? errorMessages;
  final bool success;

  BookingResult({this.appointment, this.errorMessages, this.success = false});
}
