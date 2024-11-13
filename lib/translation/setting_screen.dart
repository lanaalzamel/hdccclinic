import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/translation/languages.dart';
import '../Widgets/button.dart';
import '../Widgets/theme_controller.dart';
import 'languages_controller.dart';
// Import your theme service

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LanguagesController _controller = Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings screen'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Language Chooser Section
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: customLanguageDropdown(),
            ),
            // Toggle Theme Option
            ListTile(
              title: Text(
                'Toggle Theme'.tr,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              leading: Icon(
                Icons.brightness_6,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
              onTap: () {
                ThemeService().changeTheme(); // Change theme when tapped
              },
            ),
          ],
        ),
      ),
    );
  }

  // Custom Dropdown for Language Selection
  Widget customLanguageDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'change language'.tr,
        labelStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      value: _controller.selectedLanguage.value,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
      onChanged: (String? symbol) {
        if (symbol != null) {
          Locale locale;

          if (symbol == 'en') {
            locale = Locale('en', 'US');
          } else if (symbol == 'ar') {
            locale = Locale('ar', 'AE');
          } else {
            locale = Locale('en', 'US');
          }

          Get.updateLocale(locale);
          _controller.changeLanguage = symbol;
        }
      },
      items: languages.map((LanguageModel _language) {
        return DropdownMenuItem<String>(
          value: _language.symbol,
          child: Text(
            _language.language,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black, // Text is black here
            ),
          ),
        );
      }).toList(),
    );
  }

  // Logout function
  void _logout() {
    // Clear user session or token here, if necessary
    // Example: Userinformation.USER_TOKEN = null;
    // Navigate to login screen or do necessary logout operations
    Get.offAllNamed('/login'); // Adjust to your login route
  }
}
