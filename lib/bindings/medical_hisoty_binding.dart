// bindings/medical_history_binding.dart

import 'package:get/get.dart';
import '../module/patient/medical_history/medical_history_controller.dart';
import '../module/patient/medical_history/medical_history_service.dart';

class MedicalHistoryBinding implements Bindings {
  @override
  void dependencies() {
    print('Registering MedicalHistoryService');
    Get.put(MedicalHistoryService());
    print('Registering MedicalHistoryController');
    Get.put(MedicalHistoryController(Get.find()));
  }
}
