import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hdccapp/module/splash_screen/splash_server.dart';
import '../../config/user_info.dart';
import '../../native_service/secure_storage.dart';
import '../role/role.dart';

class SplashController extends GetxController {
  late Securestorage _storage;
  late bool validityToken;
  late SplashService _service; // underscore means private

  @override
  void onInit() async {
    validityToken = false;
    _service = SplashService();
    _storage = Securestorage();
    await checkToken();
    super.onInit();
  }

  // Function to read token
  Future<void> checkToken() async {
    String? token = await _storage.read('token');
    String ? id =await _storage.read('user_id');
    print(id);
    print('Splash token: $token');
    if (token != null) {
      await validToken(token);
      if (validityToken) {
        Userinformation.USER_TOKEN = token;
        if (_service.userType == 'Medical Technician') {
          print('go to home lab');
          Get.offAllNamed('/navigationlab');
        } else {
          print('go to home');
          Get.offAllNamed('/navigation');
        }
      } else {
        EasyLoading.showError(_service.message);
        Get.to(() => Role());
      }
    } else {
      Get.to(() => Role());
    }
  }

  Future<void> validToken(String token) async {
    validityToken = await _service.checkValid(token);
  }
}
