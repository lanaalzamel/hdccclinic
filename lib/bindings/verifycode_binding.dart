import 'package:get/get.dart';
import '../doctors/doctors_conroller.dart';
import '../module/validate_code/validate_code_controller.dart';

class verifyCodeBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<verifyCodeController>(verifyCodeController());
  }

}