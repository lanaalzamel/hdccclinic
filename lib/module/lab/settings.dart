import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/translation/languages.dart';
import '../../Widgets/theme_controller.dart';
import '../../config/user_info.dart';
import '../../native_service/secure_storage.dart';
import '../../translation/languages_controller.dart';
import '../../translation/setting_screen.dart';
import '../logout/logout_controller.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    // Initialize LogoutController if it's not already initialized
    Get.lazyPut<LogoutController>(() => LogoutController());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => ProfileContent(),
          );
        },
      ),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final LogoutController _logoutController = Get.find<LogoutController>();
  final Securestorage secureStorage = Securestorage();
  final LanguagesController _languagesController =
  Get.put(LanguagesController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 20),

            // Section: Language Selection
            _buildSectionTitle(context, 'Language'.tr),
            _buildLanguageDropdown(),
            SizedBox(height: 20),

            // Divider
            Divider(thickness: 1, color: Colors.grey[300]),

            // Section: Theme Toggle
            _buildSectionTitle(context, 'Theme'.tr),
            _buildSettingsItem('Toggle Theme'.tr, _toggleTheme),
            SizedBox(height: 20),

            // Divider
            Divider(thickness: 1, color: Colors.grey[300]),

            // Section: Logout
            _buildSectionTitle(context, 'Account'.tr),
            _buildSettingsItem('Logout'.tr, _logout),
          ],
        ),
      ),
    );
  }

  // Widget to create each settings item
  Widget _buildSettingsItem(String label, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Theme toggle function
  void _toggleTheme() {
    ThemeService().changeTheme(); // Toggle between light and dark theme
  }

  // Language dropdown for selecting language
  Widget _buildLanguageDropdown() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Obx(() {
          return DropdownButton<String>(
            value: _languagesController.selectedLanguage.value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                Locale locale;
                if (newValue == 'en') {
                  locale = Locale('en', 'US');
                } else if (newValue == 'ar') {
                  locale = Locale('ar', 'AE');
                } else {
                  locale = Locale('en', 'US');
                }
                Get.updateLocale(locale);
                _languagesController.changeLanguage = newValue;
              }
            },
            items: languages
                .map<DropdownMenuItem<String>>((LanguageModel language) {
              return DropdownMenuItem<String>(
                value: language.symbol,
                child: Text(
                  language.language,
                  // Make sure context is used here inside the Obx block where it is available
                  style: TextStyle(color: Theme.of(Get.context!).textTheme.bodyText1?.color),
                ),
              );
            }).toList(),
          );
        }),

      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
        //  fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // Logout function
  void _logout() {
    _logoutController.logout(Userinformation.USER_TOKEN);
    Get.offAllNamed('/login'); // Navigate to the login screen after logout
  }
}
