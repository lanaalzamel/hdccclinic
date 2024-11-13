import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../native_service/secure_storage.dart';

class LanguagesController extends GetxController {
  final Securestorage _storageService = Securestorage();

  // Set initial language code with fallback if Get.locale is null
  var selectedLanguage = (Get.locale?.languageCode ?? 'en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage(); // Load the saved language on initialization
  }

  Future<void> _loadLanguage() async {
    String? languageCode = await _storageService.getLanguage();
    if (languageCode != null) {
      Locale locale = Locale(languageCode);
      Get.updateLocale(locale);
      selectedLanguage.value = languageCode;
    }
  }

  set changeLanguage(String? lang) {
    if (lang != null) {
      Locale locale = Locale(lang);
      Get.updateLocale(locale);
      selectedLanguage.value = lang; // Update the observable value
      _storageService.saveLanguage(lang); // Save the selected language
    }
  }

  String getTranslation(String key) {
    return key.tr;
  }
}
