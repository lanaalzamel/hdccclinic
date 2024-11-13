import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../native_service/secure_storage.dart';

class NotificationController extends GetxController {
  final Securestorage _secureStorage = Securestorage();
  RxList<NotificationGroup> notificationGroups = <NotificationGroup>[].obs;
  RxInt unreadNotifications = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotificationsFromStorage(); // Load notifications when the controller is initialized
  }

  // Group notifications by date
  List<NotificationGroup> groupNotifications(List<RemoteMessage> notifications) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    // Sort notifications by sentTime in descending order
    notifications.sort((a, b) {
      DateTime? dateA = a.sentTime;
      DateTime? dateB = b.sentTime;

      // Handle null cases (nulls go to the end)
      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateB.compareTo(dateA); // Sort in descending order
    });

    // Group notifications by date
    final Map<String, List<RemoteMessage>> groupedNotifications = {};

    for (var notification in notifications) {
      DateTime? sentTime = notification.sentTime;

      // If sentTime is null, we skip this notification
      if (sentTime == null) continue;

      final String formattedDate = dateFormat.format(sentTime);

      if (groupedNotifications.containsKey(formattedDate)) {
        groupedNotifications[formattedDate]!.add(notification);
      } else {
        groupedNotifications[formattedDate] = [notification];
      }
    }

    // Convert the map to a list of NotificationGroup
    final List<NotificationGroup> result = [];
    groupedNotifications.forEach((date, notifications) {
      result.add(NotificationGroup(date: date, notifications: notifications));
    });

    return result;
  }

  // Save notification groups to secure storage
  Future<void> saveNotificationsToStorage() async {
    // Convert notification groups to JSON
    List<Map<String, dynamic>> notificationGroupsJson = notificationGroups.map((group) {
      return {
        'date': group.date,
        'notifications': group.notifications.map((notification) {
          return notification.data; // Storing only the notification data
        }).toList(),
      };
    }).toList();

    await _secureStorage.write(
      key: 'notifications',
      value: jsonEncode(notificationGroupsJson),
    );
  }

  // Load notification groups from secure storage
  Future<void> loadNotificationsFromStorage() async {
    String? storedNotificationsJson = await _secureStorage.read1(key: 'notifications');

    if (storedNotificationsJson != null) {
      List<dynamic> storedNotifications = jsonDecode(storedNotificationsJson);

      List<NotificationGroup> loadedGroups = storedNotifications.map((groupData) {
        return NotificationGroup(
          date: groupData['date'],
          notifications: (groupData['notifications'] as List).map((notifData) {
            return RemoteMessage(data: Map<String, dynamic>.from(notifData));
          }).toList(),
        );
      }).toList();

      notificationGroups.value = loadedGroups;
    }
  }

  // Remove a specific notification
  void removeNotification(RemoteMessage notification) {
    notificationGroups.value = notificationGroups.map((group) {
      group.notifications.removeWhere((notif) => notif.messageId == notification.messageId);
      return group;
    }).where((group) => group.notifications.isNotEmpty).toList();

    // Save updated notification list to secure storage
    saveNotificationsToStorage();
  }

  // Add new notifications
  void addNotifications(List<RemoteMessage> notifications) {
    // Expand all notifications from all groups
    final allNotifications = notificationGroups.expand((group) => group.notifications).toList();

    // Add the new notifications to the list
    allNotifications.addAll(notifications);

    // Re-group the notifications
    notificationGroups.value = groupNotifications(allNotifications);

    // Increment the unread count based on the number of new notifications
    unreadNotifications.value += notifications.length;

    // Save updated notifications to secure storage
    saveNotificationsToStorage();
  }

  // Reset unread notification badge count
  void resetBadge() {
    unreadNotifications.value = 0; // Reset unread count when the user views notifications
    saveNotificationsToStorage(); // Save this state
  }
}

// Helper class to represent notification groups
class NotificationGroup {
  final String date;
  final List<RemoteMessage> notifications;

  NotificationGroup({required this.date, required this.notifications});
}
