import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/module/patient/appointment/regularappointment/appointment_view.dart';

import '../../../Widgets/button.dart';
import '../../../utlis/global_color.dart';

class ChooseAppointment extends StatelessWidget {
  const ChooseAppointment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Select Appointment Type".tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'How soon do you need the appointment?'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1?.color,
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  children: [
                    MyButton(
                      color: Theme.of(context).primaryColor,
                      title: 'Regular appointment'.tr,
                      onTap: () {
                        Get.to(() => AppointmentPage());
                      },
                      width: 300,
                      height: 60,
                      titleColor: Colors.white,
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    MyButton(
                        titleColor:Colors.white,
                        color: Colors.red,
                        title: 'Emergency appointment'.tr,
                        onTap: () {
                          Get.toNamed('/urgentappointment');
                        },
                        width: 300,
                        height: 60),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
