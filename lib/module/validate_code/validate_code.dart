// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hdccapp/module/validate_code/validate_code_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../models/code.dart';

class VerifyCode extends StatelessWidget {
  Code code = Code();
  verifyCodeController controller = Get.find();
  @override
  Widget build(BuildContext context) {

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
          'Verification Code'.tr,
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
                  height: 20,
                ),
                Text(
                  'Check Code'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 35),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please enter the digit code that sent \n to  your email'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                 height: 5,
                ),
                OtpTextField(
                  fieldWidth: 45,
                  focusedBorderColor: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  numberOfFields: 4,
                  borderColor: Colors.blue,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (value) {
                    //handle validation or checks here
                    controller.code = value;
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    code.code = verificationCode;
                    print(code.code);
                    OnClickResetPassword(code);
                  }, // end onSubmit
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Don't have an account?".tr,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/signup');
                      },
                      child: Text(
                        "Sign up".tr,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void OnClickResetPassword(var l) async {
    EasyLoading.show(status: 'loading...');
    await controller.resetPasswordOnClick(l);
    if (controller.checkCodeStatuse) {
      print('success');
      Get.offNamed('/resetPassword');
    } else {
      EasyLoading.showError('there is an error'.tr,
          duration: Duration(seconds: 2), dismissOnTap: true);
      print('error');
    }
  }
}
