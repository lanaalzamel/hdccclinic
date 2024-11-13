// class Doctor {
//   final int id;
//   final String name;
//   final String specialty;
//
//   Doctor({required this.id, required this.name, required this.specialty});
//
//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       id: json['id'],
//       name: json['name'],
//       specialty: json['specialty'],
//     );
//   }
// }
// class Appointment {
//   final int id;
//   final int doctorId;
//   final String date;
//   final String time;
//
//   Appointment({required this.id, required this.doctorId, required this.date, required this.time});
//
//   factory Appointment.fromJson(Map<String, dynamic> json) {
//     return Appointment(
//       id: json['id'],
//       doctorId: json['doctor_id'],
//       date: json['date'],
//       time: json['time'],
//     );
//   }
// }
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/doctor.dart';
// import '../models/appointment.dart';
//
// class ApiService {
//   static const String baseUrl = 'http://your-laravel-api-url/api';
//
//   Future<List<Doctor>> getDoctors() async {
//     final response = await http.get(Uri.parse('$baseUrl/doctors'));
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.map((doctor) => Doctor.fromJson(doctor)).toList();
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
//
//   Future<List<String>> getAvailableSlots(int doctorId, String date) async {
//     final response = await http.get(Uri.parse('$baseUrl/doctors/$doctorId/available-slots?date=$date'));
//     if (response.statusCode == 200) {
//       List jsonResponse = json.decode(response.body);
//       return jsonResponse.cast<String>();
//     } else {
//       throw Exception('Failed to load available slots');
//     }
//   }
//
//   Future<void> bookAppointment(int doctorId, String date, String time) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/appointments'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'doctor_id': doctorId,
//         'date': date,
//         'time': time,
//       }),
//     );
//
//     if (response.statusCode != 201) {
//       throw Exception('Failed to book appointment');
//     }
//   }
// }
// import 'package:get/get.dart';
// import '../models/doctor.dart';
// import '../services/api_service.dart';
//
// class AppointmentController extends GetxController {
//   var doctors = <Doctor>[].obs;
//   var availableSlots = <String>[].obs;
//   var selectedDoctor = Rxn<Doctor>();
//   var selectedDate = DateTime.now().obs;
//   var selectedTime = ''.obs;
//   final ApiService apiService;
//
//   AppointmentController({required this.apiService});
//
//   @override
//   void onInit() {
//     fetchDoctors();
//     super.onInit();
//   }
//
//   void fetchDoctors() async {
//     try {
//       var fetchedDoctors = await apiService.getDoctors();
//       doctors.assignAll(fetchedDoctors);
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
//
//   void fetchAvailableSlots() async {
//     if (selectedDoctor.value != null) {
//       try {
//         var slots = await apiService.getAvailableSlots(selectedDoctor.value!.id, selectedDate.value.toIso8601String());
//         availableSlots.assignAll(slots);
//       } catch (e) {
//         Get.snackbar('Error', e.toString());
//       }
//     }
//   }
//
//   void bookAppointment() async {
//     if (selectedDoctor.value != null && selectedTime.value.isNotEmpty) {
//       try {
//         await apiService.bookAppointment(selectedDoctor.value!.id, selectedDate.value.toIso8601String(), selectedTime.value);
//         Get.snackbar('Success', 'Appointment booked successfully');
//       } catch (e) {
//         Get.snackbar('Error', e.toString());
//       }
//     }
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controllers/appointment_controller.dart';
// import 'services/api_service.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Dental Clinic',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AppointmentBookingScreen(),
//     );
//   }
// }
//
// class AppointmentBookingScreen extends StatelessWidget {
//   final AppointmentController controller = Get.put(AppointmentController(apiService: ApiService()));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book Appointment'),
//       ),
//       body: Obx(() {
//         return Column(
//           children: [
//             DropdownButton<Doctor>(
//               hint: Text('Select Doctor'),
//               value: controller.selectedDoctor.value,
//               onChanged: (Doctor? newValue) {
//                 controller.selectedDoctor.value = newValue!;
//                 controller.fetchAvailableSlots();
//               },
//               items: controller.doctors.map<DropdownMenuItem<Doctor>>((Doctor doctor) {
//                 return DropdownMenuItem<Doctor>(
//                   value: doctor,
//                   child: Text(doctor.name),
//                 );
//               }).toList(),
//             ),
//             ListTile(
//               title: Text('Select Date'),
//               trailing: Icon(Icons.calendar_today),
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: controller.selectedDate.value,
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime(DateTime.now().year + 1),
//                 );
//                 if (picked != null && picked != controller.selectedDate.value) {
//                   controller.selectedDate.value = picked;
//                   controller.fetchAvailableSlots();
//                 }
//               },
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: controller.availableSlots.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(controller.availableSlots[index]),
//                     onTap: () {
//                       controller.selectedTime.value = controller.availableSlots[index];
//                     },
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 controller.bookAppointment();
//               },
//               child: Text('Book Appointment'),
//             ),
//           ],
//         );
//       }),
//     );
//   }
// }
// // Summary
// // This code provides a basic structure for the appointment booking system using Flutter and GetX for state management,
// //     communicating with a Laravel backend. The Flutter app communicates with the backend to fetch available doctors,
// //     check available time slots, and book appointments. The AppointmentController class manages the state and API interactions,
// // while the UI allows users to select a doctor, date, and time to book an appointment