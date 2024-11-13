import 'package:get/get.dart';
import 'cancel_appointment_server.dart';
// Import your service file

class CancelAppointmentController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;
  final CancelAppointmentService _appointmentService = CancelAppointmentService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> cancelAppointment(int appointmentId) async {
    isLoading.value = true;
    try {
      await _appointmentService.cancelAppointment(appointmentId);
      message.value = 'Appointment canceled successfully';
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
