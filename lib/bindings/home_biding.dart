import 'package:get/get.dart';

import '../module/patient/home/home_controller.dart';
import '../module/patient/home/next_appointment/next_appointment_service.dart';
import '../module/patient/home/next_appointment/next_appointments_controller.dart';


class HomeBinding implements Bindings{
  @override
  void dependencies() {
    NextAppointmentService appointmentService = NextAppointmentService();
    Get.put<HomeController>(HomeController());
    Get.put<AppointmentController>(AppointmentController());
  }

}