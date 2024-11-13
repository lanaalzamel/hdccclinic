import 'package:get/get.dart';
import '../module/patient/appointment/urgent_appointment/urgent_appointment.dart';
import '../module/patient/appointment/urgent_appointment/urgent_appointment_controller.dart';

class UrgentAppointmentBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<UrgentAppointmentController>(UrgentAppointmentController());
  }

}