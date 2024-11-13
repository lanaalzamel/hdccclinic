import 'package:get/get.dart';
import '../doctors/doctors_conroller.dart';

class TestBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<DoctorsController>(DoctorsController());
  }

}