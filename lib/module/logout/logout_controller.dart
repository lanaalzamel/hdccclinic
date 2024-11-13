import 'package:get/get.dart';
import 'package:hdccapp/module/logout/logout_server.dart';
import 'package:http/http.dart ' as http;

import '../../config/server_config.dart';

class LogoutController extends GetxController{

  final LogoutService _logoutService = LogoutService();
  Future<void> logout(String token) async {
    bool success = await _logoutService.logout(token);
    if (success) {
      print('Logged out successfully');
      Get.offAllNamed('/role'); // Navigate to login screen
    } else {
      print('Failed to log out');
      Get.snackbar('Error', 'Failed to log out');
    }
  }
}


