import 'package:get/get.dart';

import '../module/patient/payments/payments_controller.dart';
import '../module/patient/payments/payments_server.dart';


class PaymentsBinding implements Bindings {
  final int patientId;  // Add patientId as a parameter

  PaymentsBinding(this.patientId); // Constructor to accept patientId

  @override
  void dependencies() {
    // Lazily initialize PaymentService and make it available
    Get.put(PaymentService());
    // Now create the PaymentController, using the patientId
    Get.put(PaymentController(Get.find()));
  }
}
