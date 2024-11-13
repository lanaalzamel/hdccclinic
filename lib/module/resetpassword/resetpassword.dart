// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:size_config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hdccapp/module/resetpassword/resetpassword_controller.dart';
import 'package:get/get.dart';
import '../../Widgets/button.dart';
import '../../Widgets/mytextdield.dart';

class reSetPassword extends StatelessWidget {
  final reSetPasswordController controller = Get.put(reSetPasswordController());
  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () {
            Get.offNamed('/login');
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
        ),
        title: Text(
          'Reset Password'.tr,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter the new password '.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Credit-Card-Font',
                  ),
                ),
                SizedBox(
                  height: 20
                ),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          hintText: 'enter your password'.tr,
                          icon: Icon(Icons.lock),
                          onChanged: (value) {
                            controller.password=value;
                          },
                          labelText: 'Password'.tr,
                          keyboard: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextField(
                          hintText: 'Re-enter your password'.tr,
                          icon: Icon(Icons.lock),
                          onChanged: (value) {
                            controller.resetpassword=value;
                          },
                          labelText: 'new password'.tr,
                          keyboard: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(
                        // height: getProportionateScreenHeight(30),
                      ),
                      SizedBox(
                        height: 20
                      ),
                      MyButton(
                        titleColor: Theme.of(context).textTheme.bodyText1?.color ?? Colors.white,
                        color: Colors.blue,
                        onTap: () {
                          OnClickRestPassword();
                        },
                        title: 'Reset password'.tr, height: 20, width: 100,
                      ),
                      SizedBox(
                        height: 20
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void OnClickRestPassword() async {
    EasyLoading.show(status: 'loading...');
    await controller.restPasswordOnClick();
    if (controller.ResetPasswordStatus) {
      EasyLoading.showSuccess('success'.tr);
      print('success');
      Get.offNamed('/navigation');
    } else {
      EasyLoading.showError('there is an error'.tr,
          duration: Duration(seconds: 10), dismissOnTap: true);
      print('error');
    }
  }
}
