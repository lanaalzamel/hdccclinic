import 'package:get/get.dart';


import '../module/login/login_controller.dart';
import '../module/login/login_lab/login_lab_controller.dart';

class LoginLabBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<LabLoginController>(LabLoginController());
  }

}