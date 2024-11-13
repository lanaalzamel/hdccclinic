import 'package:get/get.dart';

import '../config/server_config.dart';
import '../module/patient/patient_profile/patient_profile_service.dart';
import '../module/patient/patient_profile/patient_profilr_controller.dart';


class PatientProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FilterController>(
      FilterController(
        appointmentService: AppointmentService(baseUrl: ServerConfig.domainNameServer),
      ),
    );
  }
}
