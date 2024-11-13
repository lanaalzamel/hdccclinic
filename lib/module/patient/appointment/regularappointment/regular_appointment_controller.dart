// book_appointment_controller.dart
import 'package:get/get.dart';
import 'package:hdccapp/module/patient/appointment/regularappointment/regular_appointment_server.dart';
import 'package:intl/intl.dart';
import '../../../../models/show_doctors.dart';
import '../../../../models/regual_appointment.dart';
import '../../../../doctors/doctors_service.dart';
import '../../../../config/user_info.dart';


class BookAppointmentController extends GetxController {
  var isLoading = false.obs;
  var isBooked = false.obs;
  var appointment = Rxn<Appointment>();
  var doctors = <Doctors>[].obs;
  var availableTimes = <DateTime>[].obs;
  var selectedTime = ''.obs;
  var doctorId = 0.obs;
  var date = DateTime.now().obs;
  var errorMessages = <String>[].obs;
  var isLoadingTimes = false.obs;

  late BookAppointmentService appointmentService;
  late doctorsSrevecie doctorsService; // Fixed typo here

  @override
  void onInit() {
    super.onInit();
    appointmentService = BookAppointmentService();
    doctorsService = doctorsSrevecie(); // Fixed typo here
    fetchDoctors(); // Fetch doctors list on init
  }

  // Fetch doctors
  Future<void> fetchDoctors() async {
    try {
      isLoading(true);
      var fetchedDoctors = await doctorsService.getDoctors();
      doctors.value = fetchedDoctors;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Fetch available times based on doctorId and date
  Future<void> fetchAvailableTimes() async {
    try {
      isLoadingTimes(true);
      availableTimes.value = await appointmentService.fetchAvailableTimes(doctorId.value, date.value);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch available times. Please try again."); // Improved error message
    } finally {
      isLoadingTimes(false);
    }
  }

  // Book the appointment with the selected time
  Future<bool> bookAppointment() async {
    isLoading(true);
    try {
      AppointmentClass appointmentDetails = AppointmentClass(
        doctorId: doctorId.value,
        date: date.value,
        time: selectedTime.value,
        patientId: Userinformation.id.toString(),
        isBooked: false,
        status: "upcoming",
        id: 0, // Temporary, backend will set the actual ID
      );

      var result = await appointmentService.bookAppointment(appointmentDetails);

      if (result.success) {
        appointment.value = result.appointment;
        isBooked(true);
        errorMessages.clear();
        Get.offAllNamed('/navigation'); // Redirect to home screen
        return true;
      } else {
        errorMessages.value = result.errorMessages ?? ['Unknown error occurred'];
        isBooked(false); // Reset in case of failure
        return false;
      }
    } catch (e) {
      errorMessages.value = [e.toString()];
      isBooked(false); // Reset in case of exception
      return false;
    } finally {
      isLoading(false);
    }
  }
}

