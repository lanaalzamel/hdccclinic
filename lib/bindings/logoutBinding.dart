import 'package:get/get.dart';


import '../module/login/login_controller.dart';
import '../module/logout/logout_controller.dart';

class LogoutBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<LogoutController>(LogoutController());
  }

}