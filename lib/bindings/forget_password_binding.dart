import 'package:get/get.dart';
import '../module/forget_password/forget_password_controller.dart';
import '../module/patient/appointment/urgent_appointment/urgent_appointment.dart';

class ForgetPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<ForgetPasswordController>(ForgetPasswordController());
  }

}