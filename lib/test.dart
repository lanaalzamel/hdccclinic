import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/native_service/secure_storage.dart';
import 'package:hdccapp/translation/setting_screen.dart';
import 'config/user_info.dart';
import 'models/patient.dart';
import 'module/logout/logout_controller.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final LogoutController _logoutController =
      Get.find<LogoutController>(); // Make sure this is correctly instantiated

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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

  Future<Patient?> _getPatientInfo() async {
    return await secureStorage.getPatient();
  }

  Widget _buildAvatar(String? avatarUrl) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: const Size.fromRadius(40),
        child: avatarUrl != null
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/female.jpg',
                      fit: BoxFit.cover);
                },
              )
            : Image.asset(
                'assets/images/female.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Patient?>(
              future: _getPatientInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error loading patient information'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: Text('No patient information available'));
                } else {
                  Patient patient = snapshot.data!;
                  final avatarUrl = patient.avatar
                      ?.replaceAll("127.0.0.1",
                      "192.168.1.4") ?? '';
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      _buildAvatar(avatarUrl),
                      // Avatar from patient info
                      const SizedBox(height: 10),
                      Text(
                        '${patient.firstName} ${patient.lastName}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        patient.email,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      _buildSettingsItem('Medical Record'.tr,
                          () => Get.toNamed('/medicalhistory')),
                      _buildSettingsItem('My Appointments'.tr,
                          () => Get.toNamed('/appointments')),
                      _buildSettingsItem(
                          'Payments'.tr, () => Get.toNamed('/payments')),
                      _buildSettingsItem(
                          'Contact Us'.tr, () => Get.toNamed('/contactus')),
                      const Divider(),
                      _buildSettingsItem(
                          'Settings'.tr, () => Get.to(() => SettingsScreen())),
                      // _buildSettingsItem('Toggle Theme'.tr, _changeTheme), // Theme toggle option
                      _buildSettingsItem('Logout'.tr, _logout),
                      // Logout option
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  // Widget to create each settings item
  Widget _buildSettingsItem(String label, VoidCallback onTap) {
    return Card(
      child: ListTile(
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Logout function
  void _logout() {
    _logoutController.logout(Userinformation.USER_TOKEN);
    // Navigate to the login screen after logout
    Get.offAllNamed('/login');
  }
}
