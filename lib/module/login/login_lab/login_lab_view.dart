import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hdccapp/Widgets/mytextdield.dart';
import 'package:hdccapp/utlis/global_color.dart';

import '../../../Widgets/button.dart';
import '../../../Widgets/checkbox.dart';
import '../login_controller.dart';
import 'login_lab_controller.dart';


class LoginLab extends StatelessWidget {
  final LabLoginController controller = Get.put(LabLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
      body: Stack(
          children: [
      // Background image
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'), // Your background image
      fit: BoxFit.cover,
    ),
    ),
    ),SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.center,
                  child: Center(
                    child: Hero(
                      tag: 'logo',
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Log in as Laboratory'.tr,
                  style: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    hintText: 'Enter your Lab Email'.tr,
                    icon: Icon(Icons.email_sharp),
                    onChanged: (value) {
                      controller.email.value = value;
                    },
                    keyboard: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTextField(
                    hintText: 'Enter your Lab password'.tr,
                    icon: Icon(Icons.lock),
                    onChanged: (value) {
                      controller.password.value = value;
                    },
                    icon1: Icon(Icons.remove_red_eye),
                    keyboard: TextInputType.visiblePassword,
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 20),
                MyButton(
                  titleColor: Theme.of(context).textTheme.bodyText1?.color ?? Colors.white,
                  color: GlobalColors.mainColor,
                  onTap: () {
                    onClickLogin();
                  },
                  title: 'Continue as lab'.tr,
                  height: 50,
                  width: 400,
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Obx(
                            () {
                          return CustomCheckbox(
                            iconSize: 20,
                            size: 20,
                            isSelected: controller.checkBoxStatus.value,
                            onTap: () {
                              controller.changeCheckBox();
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Text('Remember me'.tr),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/forgetpassword');
                        },
                        child: Text(
                          'Forget password'.tr,
                          style:
                          TextStyle(decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
          ],
      ),
    );
  }

  void onClickLogin() async {
    if (controller.email.value.isEmpty || controller.password.value.isEmpty) {
      EasyLoading.showError('Email and password cannot be empty'.tr,
          duration: Duration(seconds: 2), dismissOnTap: true);
      return;
    }

      EasyLoading.show(status: 'loading...'.tr);
    await controller.loginLabOnClick();
    if (controller.loginStatus.value) {
      EasyLoading.showSuccess('done'.tr);
      Get.offNamed('/navigationlab');
    } else {
      EasyLoading.showError('There is an error'.tr,
          duration: Duration(seconds: 2), dismissOnTap: true);
      print('Error here'.tr);
    }
  }
}

