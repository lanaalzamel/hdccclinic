import 'package:get/get.dart';
import '../doctors/doctors_conroller.dart';
import '../module/resetpassword/resetpassword_controller.dart';

class ResetPasswordBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<reSetPasswordController>(reSetPasswordController());
  }

}