import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../config/server_config.dart';
import '../config/user_info.dart';
import '../module/notification/notification_controller.dart';
import '../module/notification/notification_screen.dart';
import 'local_notifications_service.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static const storage = FlutterSecureStorage(); // For secure storage
  static List<RemoteMessage> notifications = [];
  static final NotificationController notificationController = Get.find();

  static Future init() async {
    await messaging.requestPermission();

    // Get FCM token
    String? token = await messaging.getToken();
    if (token != null) {
      print('FCM token is: $token');
      await sendTokenToServer(token); // Check before sending
    }

    // Listen for token refreshes
    messaging.onTokenRefresh.listen((newToken) async {
      print("Refreshed FCM Token: $newToken");
      await sendTokenToServer(newToken); // Check before sending
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
    handleForeNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);  // Handle background or terminated state
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showBasicNotification(message);  // Foreground
      String? screenToNavigate = message.data['navigate_to'];
      if (screenToNavigate != null) {
        switch (screenToNavigate) {
          case 'notification_screen':
            Get.toNamed('/notifications');
            break;
          case 'appointment_screen':
            Get.toNamed('/appointments');
            break;
          case 'settings_screen':
            Get.toNamed('/settings');
            break;
        }
      }
    });
  }

  static Future<void> _handleNotificationTap(RemoteMessage message) async {
    print('Notification tapped, navigating to: ${message.data['navigate_to']}');
    String? screenToNavigate = message.data['navigate_to'];

    if (screenToNavigate != null) {
      switch (screenToNavigate) {
        case 'notification_screen':
          Get.toNamed('/notifications');
          break;
        case 'appointment_screen':
          Get.toNamed('/appointments');
          break;
        case 'settings_screen':
          Get.toNamed('/settings');
          break;
        default:
          print('Unknown screen: $screenToNavigate');
      }
    }
  }




  static Future<void> handleBackgroundNotification(RemoteMessage message) async {
    // Print notification details
    print('Background notification received:');
    if (message.notification != null) {
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    }
    print('Data: ${message.data}');

    storeNotification(message);
    if (message.data['navigate_to'] == 'appointment_cancellation_screen') {
      Get.to(() => NotificationScreen());
    }
  }

  static Future<void> handleForeNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Print notification details
      print('Foreground notification received:');
      if (message.notification != null) {
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
      }
      print('Data: ${message.data}');

      LocalNotificationService.showBasicNotification(message);
      storeNotification(message);
      if (message.data['navigate_to'] == 'appointment_cancellation_screen') {
        Get.to(() => NotificationScreen());
      }
    });
  }




  static Future<void> storeNotification(RemoteMessage message) async {
    if (!notifications.any((notif) => notif.messageId == message.messageId)) {
      notifications.add(message);
      notificationController.addNotifications([message]);

      // Save notification to secure storage
      List<String> storedNotifications = await _getStoredNotifications();
      storedNotifications.add(jsonEncode(message.data));  // Serialize notification data
      await storage.write(key: 'notifications', value: jsonEncode(storedNotifications));
    }
  }
  static Future<void> loadStoredNotifications() async {
    List<String> storedNotifications = await _getStoredNotifications();
    if (storedNotifications.isNotEmpty) {
      for (var notificationData in storedNotifications) {
        // Deserialize the notification data
        Map<String, dynamic> data = jsonDecode(notificationData);
        RemoteMessage message = RemoteMessage(
          data: data,
          // Add any other necessary fields here, like title and body
        );
        notifications.add(message);
        notificationController.addNotifications([message]);
      }
    }
  }

  static Future<List<String>> _getStoredNotifications() async {
    String? notificationsJson = await storage.read(key: 'notifications');
    if (notificationsJson != null) {
      return List<String>.from(jsonDecode(notificationsJson));
    }
    return [];
  }



  static Future<void> sendTokenToServer(String token) async {
    if (Userinformation.id == -1) {
      try {
        await Userinformation.fetchUserIdFromSecureStorage();
      } catch (e) {
        throw Exception('Failed to fetch user ID: $e');
      }
    }

    final url = ServerConfig.domainNameServer + ServerConfig.sendFCMtoken;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'patient_id': Userinformation.id.toString(),
          'device_token': token,
        }),
      );
      print('Token sent to server....');
      if (response.statusCode == 200) {
        print("Token successfully sent to server");
      } else {
        print("Failed to send token to server: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending token to server: $e");
    }
  }
}

//
// {
// "to": "device_token",
// "notification": {
// "title": "Notification Title",
// "body": "Notification Body"
// },
// "data": {
// "navigate_to": "notification_screen"
// }
// }
