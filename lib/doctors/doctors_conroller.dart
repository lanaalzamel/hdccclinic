import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/show_doctors.dart';
import '../native_service/secure_storage.dart';
import 'doctors_service.dart';

class DoctorsController extends GetxController {
  late Securestorage _storage;
  late doctorsSrevecie _service;
  var doctorsMap = <int, Doctors>{}.obs; // Updated to store Doctors objects

  @override
  void onInit() {
    _storage = Securestorage();
    _service = doctorsSrevecie();
    super.onInit();
    readDoctorsInfo();
  }

  Future<void> readDoctorsInfo() async {
    List<Doctors?> doctorsList = [];

    // Fetch all doctors' info from secure storage (assuming it returns Doctors objects)
    for (int i = 1; i <= 10; i++) {
      Doctors? doctor = await _storage.getAppointment(); // Adjust method as per your Securestorage implementation
      if (doctor != null) {
        doctorsList.add(doctor);
      }
    }

    // Fetch doctors' info from the service
    try {
      List<Doctors> doctorsFromService = await _service.getDoctors();
      doctorsList.addAll(doctorsFromService);
    } catch (e) {
      print('Failed to load doctor info from service: $e');
    }

    // Store doctors in doctorsMap
    for (var doctor in doctorsList) {
      if (doctor != null) {
        doctorsMap[doctor.id] = doctor;
      }
    }

    // Print the map for verification
    doctorsMap.forEach((id, doctor) {
      print('ID: $id, Name: ${doctor.firstName} ${doctor.lastName}, Start Work: ${doctor.startWork}, Finish Work: ${doctor.finishWork}');
    });
  }

  List<String> getAvailableTimes(int doctorId) {
    final doctor = doctorsMap[doctorId];
    if (doctor == null) return [];

    DateTime startTime = DateFormat("HH:mm:ss").parse(doctor.startWork!);
    DateTime endTime = DateFormat("HH:mm:ss").parse(doctor.finishWork!);

    if (endTime.isBefore(startTime)) {
      // Handle case where end time is past midnight
      endTime = endTime.add(Duration(days: 1));
    }

    List<String> availableTimes = [];

    while (startTime.isBefore(endTime)) {
      availableTimes.add(DateFormat("HH:mm").format(startTime));
      startTime = startTime.add(Duration(minutes: 60));
    }

    return availableTimes;
  }
}
