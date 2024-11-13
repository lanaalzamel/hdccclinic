import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../native_service/secure_storage.dart';

class ThemeController extends GetxController {
  final Securestorage _secureStorage = Securestorage();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    isDarkMode.value = await _secureStorage.getThemeMode();
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _secureStorage.setThemeMode(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
