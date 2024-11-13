import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hdccapp/config/user_info.dart';
import 'package:hdccapp/firebase_options.dart';
import 'package:hdccapp/module/login/login_lab/login_lab_view.dart';
import 'package:hdccapp/module/patient/Contact_us/contact_us.dart';
import 'package:hdccapp/module/splash_screen/splash_view.dart';
import 'package:hdccapp/services/firebase_notifications.dart';
import 'package:hdccapp/services/local_notifications_service.dart';
import 'package:hdccapp/test.dart';
import 'package:hdccapp/translation/languages_controller.dart';
import 'package:hdccapp/translation/translation.dart';
import 'package:hdccapp/utlis/theme_controller.dart';
import 'Widgets/navigation_menu_lab.dart';
import 'Widgets/navigation_menu_patient.dart';
import 'Widgets/theme_controller.dart';
import 'bindings/appointment_binding.dart';
import 'bindings/chat_binding.dart';
import 'bindings/forget_password_binding.dart';
import 'bindings/home_biding.dart';
import 'bindings/home_lab_binding.dart';
import 'bindings/login_binding.dart';
import 'bindings/login_lab_binding.dart';
import 'bindings/medical_hisoty_binding.dart';
import 'bindings/patient_profile_binding.dart';
import 'bindings/payments_binding.dart';
import 'bindings/resetpassword_binding.dart';
import 'bindings/splash_binding.dart';
import 'bindings/test_binding.dart';
import 'bindings/verifycode_binding.dart';
import 'error_screen.dart';
import 'models/chat_model.dart';
import 'models/show_doctors.dart';
import 'module/forget_password/forget_password.dart';
import 'module/lab/lab_home/lab_home.dart';
import 'module/login/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'module/logout/logout_controller.dart';
import 'module/notification/notification_controller.dart';
import 'module/notification/notification_screen.dart';
import 'module/patient/all_appointments/all_appointmenta.dart';
import 'module/patient/appointment/urgent_appointment/urgent_appointment.dart';
import 'module/patient/chat/home_chat.dart';
import 'module/patient/home/home_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'module/patient/medical_history/medical_history.dart';
import 'module/patient/patient_profile/patient_profile.dart';
import 'module/patient/payments/payments.dart';
import 'module/resetpassword/resetpassword.dart';
import 'module/role/role.dart';
import 'module/validate_code/validate_code.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'native_service/secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure initialized first

  // Initialize Firebase and GetStorage in parallel
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    GetStorage.init(),
  ]);

  // Initialize Hive and register adapters
  await Hive.initFlutter();
  Hive.registerAdapter(DoctorsAdapter());
  Hive.registerAdapter(ChatAdapter());
  await Hive.openBox<Doctors>('doctors');
  await Hive.openBox<Chat>('chats');

  // Initialize Push and Local Notification services in parallel
  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);

  // Initialize Secure Storage for language settings
  final Securestorage _storageService = Securestorage();
  final storedLanguageCode = await _storageService.getLanguage();
  final initialLocale = storedLanguageCode != null
      ? Locale(storedLanguageCode)
      : const Locale('en', 'US');

  // Initialize GetX controllers
  Get.put(ThemeController()); // Initialize ThemeController early
  Get.put(LanguagesController());
  Get.put(NavigationControllerPatient());
  Get.put(NavigationControllerLab());
  Get.put(NotificationController());
  Get.put<LogoutController>(LogoutController());
  // Run the Flutter app
  runApp(MyApp(initialLocale: initialLocale));
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); // Define navigatorKey here

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  final ThemeService _themeService = ThemeService();

  MyApp({required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      theme: _themeService.lightTheme,
      darkTheme: _themeService.darkTheme,
      themeMode: _themeService.getThemeMode(),
      debugShowCheckedModeBanner: false,
      translations: AppTranslation(),
      // Ensure this is properly defined
      locale: initialLocale,
      // Use the initial locale passed to MyApp
      fallbackLocale: Locale('en', 'US'),

      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/login', page: () => Login(), binding: LoginBinding()),
        GetPage(
            name: '/labLogin',
            page: () => LoginLab(),
            binding: LoginLabBinding()),
        GetPage(
            name: '/splash', page: () => Splash(), binding: SplashBinding()),
        // GetPage(
        //   name: '/chat',
        //   page: () {
        //     final args = Get.arguments ?? {}; // Ensure arguments are not null
        //     return ChatScreen(
        //       chatId: args['chatId'] ?? 0,  // Provide a default value if null
        //       patientId: args['patientId'] ?? 0,
        //       doctorId: args['doctorId'] ?? 0,
        //     );
        //   },
        //   binding: ChatBinding(),
        // ),

        GetPage(
          name: '/notification',
          page: () {
            // Check if Get.arguments is not null and cast it
            final message =
                Get.arguments != null ? Get.arguments as RemoteMessage : null;

            // If message is null, handle it appropriately
            if (message == null) {
              // Handle null case, e.g., navigate back, show an error, etc.
              print("Error: No message received");
              // You might want to return an error screen or navigate back
              return ErrorScreen(
                  message:
                      'Failed to retrieve the notification message.'); // Replace with your error handling widget or screen
            }

            return NotificationScreen();
          },
        ),
        GetPage(name: '/home', page: () => Home(), binding: HomeBinding()),
        GetPage(
          name: '/medicalhistory',
          page: () => MedicalHistoryView(),
          binding: MedicalHistoryBinding(),
        ),
        GetPage(
          name: '/contactus',
          page: () => ContactUsPage(),
        ),
        GetPage(
            name: '/lab', page: () => LabHome(), binding: HomeLabBinding()),
        GetPage(
            name: '/urgentappointment',
            page: () => UrgentAppointment(),
            binding: UrgentAppointmentBinding()),
        GetPage(name: '/ProfileScreen', page: () => ProfileScreen(), binding: TestBinding()),
        GetPage(
            name: '/resetPassword',
            page: () => reSetPassword(),
            binding: ResetPasswordBinding()),
        GetPage(
            name: '/forgetpassword',
            page: () => ForgetPassword(),
            binding: ForgetPasswordBinding()),
        GetPage(
            name: '/verifycode',
            page: () => VerifyCode(),
            binding: verifyCodeBinding()),
        GetPage(
          name: '/role',
          page: () => Role(),
        ),
        // GetPage(
        //     name: '/patientprofile',
        //     page: () => PatientProfile(),
        //     binding: PatientProfileBinding()),
        GetPage(
          name: '/navigation',
          page: () => NavigationMenuPatient(),
        ), GetPage(
          name: '/navigationlab',
          page: () => NavigationMenuLab(),
        ),
        GetPage(
            name: '/payments',
            page: () => PaymentView(patientId: Userinformation.id),
            binding: PaymentsBinding(Userinformation.id)),
        GetPage(
          name: '/appointments',
          page: () => AllAppointment(), // Do not pass appointments here
          binding: PatientProfileBinding(),
        ),
      ],
      builder: EasyLoading.init(),
    );
  }
}
