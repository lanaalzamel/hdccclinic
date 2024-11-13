import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/config/user_info.dart';
import 'package:hdccapp/module/patient/chat/chat_list_screen.dart';
import 'package:hdccapp/utlis/global_color.dart';
import 'package:hdccapp/models/patient.dart';
import 'package:hdccapp/native_service/secure_storage.dart';

import '../../../Widgets/theme_controller.dart';
import '../../../translation/languages.dart';
import '../../../translation/languages_controller.dart';
import '../../../translation/setting_screen.dart';
import '../../logout/logout_controller.dart';
import '../Contact_us/contact_us.dart';
import '../chat/home_chat.dart';

class PatientHomedrawer extends StatelessWidget {
  PatientHomedrawer({Key? key}) : super(key: key);

  final Securestorage secureStorage = Securestorage();
  final LogoutController _logoutController = Get.put(LogoutController());
  final LanguagesController _translatecontroller =
      Get.put(LanguagesController());

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
                  return Image.asset('assets/images/profile.jpg',
                      fit: BoxFit.cover);
                },
              )
            : Image.asset(
                'assets/images/profile.jpg',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Patient?>(
        future: _getPatientInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading patient information'.tr));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No patient information available'.tr));
          } else {
            Patient patient = snapshot.data!;
            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/background.jpg',
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5), // Overlay color with opacity
                        BlendMode.srcATop, // Blending mode
                      ),
                    ),
                    // color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/patientprofile');
                          },
                          child: _buildAvatar(patient.avatar),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed('/patientprofile');
                            },
                            child: Center(
                              child: Text(
                                '${patient.firstName} ${patient.lastName}'.tr,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.color,
                                ),
                              ),
                            ),
                          ),
                          // Text(
                          //   patient.email ?? '',
                          //   style: TextStyle(
                          //     fontFamily: "Poppins",
                          //     color: GlobalColors.textColor,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    'Appointment'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(Icons.calendar_month_outlined,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  onTap: () {
                    Get.toNamed('/appointments');
                  },
                ),                ListTile(
                  title: Text(
                    'Medical History'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(Icons.location_history_outlined,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  onTap: () {
                    Get.toNamed('/medicalhistory');
                  },
                ),
                ListTile(
                  title: Text(
                    'Bills'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(CupertinoIcons.money_dollar_circle,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  onTap: () {
                    Get.toNamed('/payments');
                  },
                ),
                ListTile(
                  title: Text(
                    'Chat'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(CupertinoIcons.chat_bubble_2,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  onTap: () {
                    Get.to(
                      PatientChatListScreen(patientId: Userinformation.id,),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    'Contact Us'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(
                    Icons.contact_page_outlined,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                  onTap: () {
                    Get.to(() => ContactUsPage());
                  },
                ),
                ListTile(
                  title: Text(
                    'Settings'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(
                    Icons.settings,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                  onTap: () {
                    Get.to(() => SettingsScreen());

                  },
                ),
                ListTile(
                  leading: Icon(CupertinoIcons.moon_stars,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  title: Text(
                    'Toggle Theme'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  onTap: () {
                    ThemeService().changeTheme(); // Change theme when tapped
                    //  Navigator.pop(context); // Close the drawer
                  },
                ),
                Divider(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                  endIndent: 10,
                  indent: 10,
                ),
                ListTile(
                  title: Text(
                    'Logout'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                  leading: Icon(Icons.logout_outlined,
                      color: Theme.of(context).textTheme.bodyText1?.color),
                  onTap: () {
                    _logoutController.logout(Userinformation.USER_TOKEN);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  DropdownButton languageChooser() {
    return DropdownButton<String>(
        isExpanded: false,
        hint: Text('change language'.tr),
        // Not necessary for Option 1
        value: _translatecontroller.selectedLanguage?.value,
        onChanged: (symbol) {
          _translatecontroller.changeLanguage = symbol;
        },
        items: languages.map((LanguageModel _language) {
          print(_language.language);
          return DropdownMenuItem<String>(
            child: new Text(_language.language),
            value: _language.symbol,
          );
        }).toList());
  }
}
