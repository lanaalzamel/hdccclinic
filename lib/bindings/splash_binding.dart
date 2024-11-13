import 'package:get/get.dart';
import '../doctors/doctors_conroller.dart';
import '../module/splash_screen/splash_controller.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }

}