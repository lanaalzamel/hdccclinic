import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/config/user_info.dart';

import 'package:hdccapp/utlis/global_color.dart';
import '../../../models/user_lab.dart';
import '../../../native_service/secure_storage.dart';
import '../../notification/notification_controller.dart';
import '../../notification/notification_screen.dart';
import '../../patient/drawer/patient_drawer.dart';
import '../doctor_request_details/request_record_details.dart';
import '../doctor_request_details/request_today_details.dart';
import 'home_lab_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'new_lab_request_list/new_lab_request_list_controller.dart';

class LabHome extends StatelessWidget {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LabRequestController controller = Get.put(LabRequestController());
  final TodayLabRequestListController todayRequestController =
      Get.put(TodayLabRequestListController());
  final Securestorage secureStorage = Securestorage();

  Future<Medicaltech?> _getMedicaltechInfo() async {
    return await secureStorage.getMedicaltech();
  }

  @override
  Future<void> _refreshLabRequests() async {
    await controller.fetchLabRequests(Userinformation.id);
    await todayRequestController.fetchLabRequests(Userinformation.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //key: _scaffoldKey,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshLabRequests,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              child: FutureBuilder<Medicaltech?>(
                future: _getMedicaltechInfo(), // Fetch Medicaltech info
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    Medicaltech? medicaltech = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(
                           // scaffoldKey: _scaffoldKey,
                            medicaltech: medicaltech),
                        // Pass medicaltech here
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            // Light blue background for today
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const SectionHeader(
                                  title: 'Today\'s Requests',
                                  icon: Icons.today, // Adding an icon
                                ),
                              ),
                              const SizedBox(height: 10),
                              RequestList(
                                  todayRequestController:
                                      todayRequestController),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        // **Request History Section**
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const SectionHeader(
                                  title: 'Pending Lab Requests',
                                  icon: Icons.history, // Adding an icon
                                ),
                              ),
                              const SizedBox(height: 10),
                              RequestRecord(controller: controller),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('No Medicaltech info available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        // Icon to differentiate sections
        const SizedBox(width: 8),
        Text(
          title.tr,
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  //final GlobalKey<ScaffoldState> scaffoldKey;
  final Medicaltech? medicaltech; // Add this parameter

  const Header({this.medicaltech});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back'.tr,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins",
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
              Text(
                '${'Lab'.tr}  ${medicaltech!.name}'.tr,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1?.color,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Obx(() {
          bool hasNewNotification =
              notificationController.unreadNotifications > 0;

          return IconButton(
            icon: badges.Badge(
              badgeContent: Text(
                hasNewNotification
                    ? notificationController.unreadNotifications.toString()
                    : '',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              showBadge: hasNewNotification,
              badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
              child: const Icon(Icons.notifications),
            ),
            onPressed: () {
              notificationController
                  .resetBadge(); // Reset badge count when icon is pressed
              Get.to(
                  () => NotificationScreen()); // Navigate to NotificationScreen
            },
          );
        }),
      ],
    );
  }
}

class RequestList extends StatelessWidget {
  final TodayLabRequestListController todayRequestController;

  const RequestList({required this.todayRequestController});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 215,
        width: 332,
        child: Obx(() {
          if (todayRequestController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (todayRequestController.labRequests.isNotEmpty) {
            var reversRequest =
                List.from(todayRequestController.labRequests.reversed);
            return ListView.separated(
              itemCount: todayRequestController.labRequests.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[50],
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                var labRequest = reversRequest[index];
                print('Doctor Name: ${labRequest.doctorName}');
                return ListTile(
                  onTap: () {
                    todayRequestController
                        .markRequestAsOpened(labRequest.id); // Mark as opened
                    Future.delayed(const Duration(milliseconds: 100), () {
                      Get.to(() => RequesTodayDetailsPage(request: labRequest));
                    });
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        radius: 25,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Obx(() {
                        return todayRequestController.newRequestIds
                                .contains(labRequest.id)
                            ? Positioned(
                                right: 0,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color:
                                        Colors.red, // Dot color for new request
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(); // No dot if not new
                      }),
                    ],
                  ),
                  title: Text(
                    '${'doctor_title'.tr}${labRequest.doctorName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontFamily: "Poppins",
                    ),
                  ),
                  subtitle: Text(
                    labRequest.patientName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontFamily: "Poppins",
                    ),
                  ),
                  trailing: Icon(
                    CupertinoIcons.paperclip,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox,
                      size: 40,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'It’s quiet today! No lab requests have come in yet.'.tr,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontFamily: "Poppins",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Stay tuned!'.tr,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontFamily: "Poppins",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}

class RequestRecord extends StatelessWidget {
  final LabRequestController controller;

  const RequestRecord({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 215,
        width: 332,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.labRequests.isNotEmpty) {
            var reversRequest = List.from(controller.labRequests.reversed);
            return ListView.separated(
              itemCount: controller.labRequests.length,
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                // Light separator
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                var labRequest = reversRequest[index];
                return ListTile(
                  onTap: () {
                    Get.to(() => RequestRecordDetailsPage(request: labRequest));
                  },
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    radius: 25,
                  ),
                  title: Row(
                    children: [
                      Text(
                        '${'doctor_title'.tr}${labRequest.doctorName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontFamily: "Poppins",
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Add Pending label here
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Pending'.tr,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    labRequest.patientName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                      fontFamily: "Poppins",
                    ),
                  ),
                  // trailing: Icon(
                  //   CupertinoIcons.paperclip,
                  //   color: GlobalColors.mainColor,
                  //   size: 24,
                  // ),
                );
              },
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.inbox,
                        size: 40,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No requests found.'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontFamily: "Poppins",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Please check back later.'.tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontFamily: "Poppins",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
