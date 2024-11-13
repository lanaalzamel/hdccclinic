import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notificationController = Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: notificationController.notificationGroups.length,
          itemBuilder: (context, index) {
            NotificationGroup group =
                notificationController.notificationGroups[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(group.date,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                ...group.notifications.map((RemoteMessage notification) {
                  return Dismissible(
                    key: Key(notification.messageId ?? ''),
                    // Unique key for each item
                    direction: DismissDirection.endToStart,
                    // Swipe from right to left
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      notificationController.removeNotification(notification);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Notification deleted'),
                      ));
                    },
                    child: ListTile(
                      title:
                          Text(notification.notification?.title ?? 'No Title'),
                      subtitle:
                          Text(notification.notification?.body ?? 'No Body'),
                      leading: Icon(Icons.notifications),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
