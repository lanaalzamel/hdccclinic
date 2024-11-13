import 'package:get/get.dart';
import 'package:hdccapp/module/patient/patient_profile/patient_profile_service.dart';
import '../../../config/user_info.dart';
import '../../../models/appointment_by_status_model.dart';

class FilterController extends GetxController {
  RxString selectedOption = 'All'.obs;
  var appointments = <AppointmentByStatus>[].obs;

  final AppointmentService appointmentService;

  FilterController({required this.appointmentService});

  @override
  void onInit() {
    super.onInit();
    fetchAppointments('All', Userinformation.id); // Fetch all appointments by default
  }

  Future<void> fetchAppointments(String status, int userId) async {
    try {
      List<AppointmentByStatus> fetchedAppointments = [];

      if (status == 'All') {
        // If you want to fetch all statuses separately
        List<String> statuses = ['Upcoming', 'Completed', 'Canceled'];
        for (var s in statuses) {
          var statusAppointments = await appointmentService.fetchAppointmentsByStatus(s, userId);
          if (statusAppointments.isNotEmpty) {
            fetchedAppointments.addAll(statusAppointments);
          }
        }
      } else {
        fetchedAppointments = await appointmentService.fetchAppointmentsByStatus(status, userId);
      }

      // Update observable list
      appointments.assignAll(fetchedAppointments);
    } catch (e) {
      print('Failed to fetch appointments: $e');
      // Handle the error as needed (e.g., show an error message in the UI)
    }
  }
}
