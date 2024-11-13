import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeService extends ChangeNotifier {

  // Light mode colors
  final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: HexColor('#FAFAFA'),
    primaryColor: HexColor('#3ED3CE'),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: HexColor('#707070')),
      bodyText2: TextStyle(color: HexColor('#707070')),
      headline6: TextStyle(color: Colors.black.withOpacity(0.7)),
    ),
    iconTheme: IconThemeData(
      color: HexColor('#707070'), // Icon color for light mode
      size: 24.0, // Default icon size
    ),
    cardColor: Colors.white,
    // Add custom colors for light mode
    colorScheme: ColorScheme.light().copyWith(
      background: HexColor('#eeecee'), // Background color for light mode
      onBackground: HexColor('#eeecee').withOpacity(0.5), // Overlay for light mode
    ),

  );

  // Dark mode colors
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: HexColor('#121212'),
    primaryColor: HexColor('#2b9b8f'),
    cardColor: Colors.grey[800],
    textTheme: TextTheme(
      bodyText1: TextStyle(color: HexColor('#E0E0E0')),
      bodyText2: TextStyle(color: HexColor('#A0A0A0')),
      headline6: TextStyle(color: Colors.white.withOpacity(0.5)),
    ),
    iconTheme: IconThemeData(
      color: HexColor('#E0E0E0'), // Icon color for dark mode
      size: 24.0, // Default icon size
    ),

    // Add custom colors for dark mode
    colorScheme: ColorScheme.dark().copyWith(
      background: HexColor('##101115'), // Background color for dark mode
      onBackground: HexColor('#000000').withOpacity(0.5), // Overlay for dark mode
    ),
  );

  final _getStorage = GetStorage();
  final _darkThemeKey = 'isDarkTheme';

  void saveThemeData(bool isDarkMode) {
    _getStorage.write(_darkThemeKey, isDarkMode);
  }

  bool isSavedDarkMode() {
    return _getStorage.read(_darkThemeKey) ?? false;
  }

  ThemeMode getThemeMode() {
    return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
  }

  void changeTheme() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeData(!isSavedDarkMode());
  }
}
//for background
//Theme.of(context).colorScheme.onBackground.withOpacity(0.5),

//for text
// Theme.of(context).textTheme.bodyText1?.color,

//for primary
// Theme.of(context).primaryColor,