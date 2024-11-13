import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hdccapp/utlis/global_color.dart';

import '../login/login_controller.dart';
import '../login/login_lab/login_lab_controller.dart';
import '../login/login_lab/login_lab_view.dart';


class Role extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final LabLoginController labLoginController = Get.put(LabLoginController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/tooth.png',
                        // Adjust this path if necessary
                        height: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'HDCC',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'c  l  i  n  i  c',
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Welcome section
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome'.tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'welcome to our clinic! Please choose your role to proceed.'.tr,
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                loginController.setSelectedRole('patient');
                                Get.toNamed('/login');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Patient'.tr,
                                style: TextStyle(fontSize: 16,fontFamily: "Poppins",),
                              ),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                labLoginController.setSelectedRole('lab');
                                Get.to(() => LoginLab());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  //side: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Text(
                                'Lab'.tr,
                                style: TextStyle(fontSize: 16,fontFamily: "Poppins",),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
