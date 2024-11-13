import 'package:get/get.dart';

import '../module/lab/lab_home/home_lab_controller.dart';
import '../module/patient/home/home_controller.dart';
import '../module/patient/home/next_appointment/next_appointment_service.dart';
import '../module/patient/home/next_appointment/next_appointments_controller.dart';


class HomeLabBinding implements Bindings{
  @override
  void dependencies() {

    Get.put<LabRequestController>(LabRequestController());

  }

}