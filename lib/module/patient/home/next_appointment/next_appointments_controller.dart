import 'package:get/get.dart';
import 'package:hdccapp/config/user_info.dart';
import 'package:hdccapp/models/next_appointment.dart';
import 'next_appointment_service.dart';

class AppointmentController extends GetxController {
  var isLoading = true.obs;
  NextAppointmentService _appointmentService = NextAppointmentService();
  NextAppointment? _nextAppointment;

  NextAppointment? get nextAppointment => _nextAppointment;

  @override
  void onReady() {
    super.onReady();
    checkAuthenticationAndNavigate();
  }

  void checkAuthenticationAndNavigate() async {
    try {
      await Userinformation.fetchUserIdFromSecureStorage();
      fetchNextAppointment();
    } catch (e) {
      print('Error initializing: $e');
    }
  }

  Future<void> fetchNextAppointment() async {
    try {
      isLoading(true);
      _nextAppointment = await _appointmentService.getNextAppointment(Userinformation.USER_TOKEN);
      print("Fetched appointment: ${_nextAppointment?.toJson()}");
    } catch (e) {
      print("Error loading next appointment: $e");
      _nextAppointment = null;
    } finally {
      isLoading(false);
    }
  }
}
