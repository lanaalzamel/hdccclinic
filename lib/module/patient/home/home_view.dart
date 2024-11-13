import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/config/user_info.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hdccapp/utlis/global_color.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../../../models/patient.dart';
import '../../../native_service/secure_storage.dart';
import '../../notification/notification_controller.dart';
import '../../notification/notification_screen.dart';
import '../all_appointments/all_appointmenta.dart';
import '../appointment/choose_appointment.dart';
import '../cancel_appointment/cancel_appointment_controller.dart';
import '../chat/chat_list_screen.dart';
import '../drawer/patient_drawer.dart';
import '../patient_profile/patient_profile.dart';
import '../recommendation/recommendation_controller.dart';
import 'home_controller.dart';
import 'package:intl/intl.dart';
import 'next_appointment/next_appointments_controller.dart';
import 'package:hdccapp/utlis/theme_controller.dart' as UtlisThemeController;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

  class _HomeState extends State<Home> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    bool _isDrawerOpen = false;
    final HomeController controller = Get.put(HomeController());
    final GlobalKey _iconKey = GlobalKey();
    final AppointmentController appointmentcontroller =
        Get.put(AppointmentController());
    CancelAppointmentController cancelAppointmentController =
        Get.put(CancelAppointmentController());
    final RecommendationController recommendationcontroller =
        Get.put(RecommendationController());
    final Securestorage secureStorage = Securestorage();
    final UtlisThemeController.ThemeController themeController =
        Get.put(UtlisThemeController.ThemeController());

    Future<Patient?> _getPatientInfo() async {
      return await secureStorage.getPatient();
    }

  void _showCancelConfirmationDialog(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'.tr),
          content: Text('Are you sure you want to cancel this appointment?'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'.tr),
            ),
            TextButton(
              onPressed: () {
                cancelAppointmentController.cancelAppointment(appointmentId);
                Navigator.pop(context);
              },
              child: Text('Yes'.tr),
            ),
          ],
        );
      },
    );
  }

  void _showMenu(BuildContext context) {
    final RenderBox renderBox =
        _iconKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final double dx = position.dx;
    final double dy = position.dy + renderBox.size.height;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, 0, 0),
      items: [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              Get.back(); // Close the menu
              _showCancelConfirmationDialog(
                  appointmentcontroller.nextAppointment!.appointmentId);
            },
            child: Text(
              'Cancel Appointment'.tr,
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        //backgroundColor: GlobalColors.backgroundColor,
        endDrawer: PatientHomedrawer(),
        body: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              transform:
                  Matrix4.translationValues(_isDrawerOpen ? -250 : 0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FutureBuilder<Patient?>(
                  future: _getPatientInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error loading patient information'.tr));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(
                          child: Text('No patient information available'.tr));
                    } else {
                      Patient patient = snapshot.data!;
                      return RefreshIndicator(
                        onRefresh: () async {
                          await appointmentcontroller.fetchNextAppointment();
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed('/patientprofile');
                                      },
                                      child: ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(35),
                                          child: Builder(
                                            builder: (context) {
                                              print(
                                                  'Patient Avatar URL: ${patient.avatar}');
                                              final avatarUrl = patient.avatar
                                                      ?.replaceAll("127.0.0.1",
                                                          "192.168.1.4") ??
                                                  '';
                                              return patient.avatar != null &&
                                                      patient.avatar.isNotEmpty
                                                  ? Image.network(
                                                      avatarUrl,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (BuildContext context,
                                                              Object exception,
                                                              StackTrace?
                                                                  stackTrace) {
                                                        print(
                                                            'Failed to load image: $exception');
                                                        return Image.asset(
                                                          'assets/images/female.jpg',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    )
                                                  : Image.asset(
                                                      'assets/images/female.jpg',
                                                      fit: BoxFit.cover,
                                                    );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back'.tr,
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('/patientprofile');
                                        },
                                        child: Text(
                                          '${patient.firstName} ${patient.lastName}',
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Obx(() {
                                    bool hasNewNotification =
                                        notificationController
                                                .unreadNotifications >
                                            0;

                                    return IconButton(
                                      icon: badges.Badge(
                                        badgeContent: Text(
                                          hasNewNotification
                                              ? notificationController
                                                  .unreadNotifications
                                                  .toString()
                                              : '',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                        showBadge: hasNewNotification,
                                        badgeStyle: badges.BadgeStyle(
                                            badgeColor: Colors.red),
                                        child: Icon(Icons.notifications),
                                      ),
                                      onPressed: () {
                                        notificationController
                                            .resetBadge(); // Reset badge count when icon is pressed
                                        Get.to(() =>
                                            NotificationScreen()); // Navigate to NotificationScreen
                                      },
                                    );
                                  }),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Upcoming visit'.tr,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            ?.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Obx(() {
                                if (appointmentcontroller.isLoading.isTrue) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 5,
                                    ),
                                  );
                                }
                                if (appointmentcontroller.nextAppointment ==
                                    null) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.thumb_up,
                                            size: 50,
                                            color: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.7)),
                                        const SizedBox(height: 10),
                                        Text(
                                          'You’re all caught up!'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color
                                                ?.withOpacity(0.7),
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'No upcoming appointments.'.tr,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.color
                                                ?.withOpacity(0.7),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final photoUrl = appointmentcontroller
                                        .nextAppointment!.doctor.photo
                                        ?.replaceAll(
                                            "127.0.0.1", "192.168.1.4") ??
                                    '';
                                print('next appointment photo:');
                                print(photoUrl);
                                return Container(
                                  height: 175,
                                  width: 500,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 25,
                                                      backgroundImage: NetworkImage(photoUrl),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${'doctor_title'.tr} ${appointmentcontroller.nextAppointment!.doctor.firstName} '
                                                              '${appointmentcontroller.nextAppointment!.doctor.lastName}',
                                                          style: const TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${DateFormat('d MMMM yyyy').format(appointmentcontroller.nextAppointment!.appointmentDate)}',
                                                          style: const TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${DateFormat.jm().format(appointmentcontroller.nextAppointment!.appointmentDate)}',
                                                          style: const TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 17,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                              }),
                              const SizedBox(height: 30),
                              Text(
                                'Get a New Appointment'.tr,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.color,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => const ChooseAppointment());
                                  },
                                  child: Container(
                                    height: 70,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              'Book Now'.tr,
                                              style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 17,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 25.0),
                                          child: Icon(
                                            Icons.arrow_forward,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Recommendation'.tr,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.color,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Obx(() {
                                if (recommendationcontroller.isLoading.value) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (recommendationcontroller
                                    .recommendations.isNotEmpty) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25, // 25% of screen height
                                    child: PageView.builder(
                                      itemCount: recommendationcontroller
                                          .recommendations.length,
                                      itemBuilder: (context, index) {
                                        var recommendation =
                                            recommendationcontroller
                                                .recommendations[index];
                                        String photoUrl = recommendation
                                                .doctor.photo
                                                ?.replaceFirst("127.0.0.1",
                                                    "192.168.1.4") ??
                                            '';
                                        return Container(
                                          height: MediaQuery.of(context).size.height * 0.22,
                                          width: MediaQuery.of(context).size.width * 0.85,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      recommendation.recommendation,
                                                      style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 4,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      if (recommendation.doctor.photo != null)
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(photoUrl),
                                                          radius: MediaQuery.of(context).size.width * 0.05,
                                                        )
                                                      else
                                                        CircleAvatar(
                                                          backgroundColor: GlobalColors.mainColor,
                                                          radius: MediaQuery.of(context).size.width * 0.05,
                                                          child: const Icon(
                                                            Icons.person,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      const SizedBox(width: 8),
                                                      Flexible(
                                                        child: Text(
                                                          '${'doctor_title'.tr}${recommendation.doctor.name}',
                                                          style: const TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );

                                      },
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'We’re working on it! Check back soon.'
                                          .tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.color
                                            ?.withOpacity(0.7),
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
