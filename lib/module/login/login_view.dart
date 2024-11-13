import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/Widgets/mytextdield.dart';
import 'package:hdccapp/utlis/global_color.dart';

import '../../Widgets/button.dart';
import '../../Widgets/checkbox.dart';
import '../../services/auth_firbase_service.dart';
import 'login_controller.dart';

class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/background.jpg'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          // Login form
          SingleChildScrollView(
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
                      'Log in'.tr,
                      style: TextStyle(
                        color: GlobalColors.textColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyTextField(
                        hintText: 'Enter your Email'.tr,
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
                      child: Obx(() => MyTextField(
                        hintText: 'Enter your password'.tr,
                        icon: Icon(Icons.lock),
                        onChanged: (value) {
                          controller.password.value = value;
                        },
                        icon1: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        keyboard: TextInputType.visiblePassword,
                        obscureText: !controller.isPasswordVisible.value,
                      )),
                    ),
                    SizedBox(height: 20),
                    Obx(() => MyButton(
                      titleColor:
                      Theme.of(context).textTheme.bodyText1?.color ??
                          Colors.white,
                      color: Theme.of(context).primaryColor,
                      onTap: () {
                        onClickLogin();
                      },
                      title: controller.loading.value
                          ? '' // No text when loading
                          : 'Continue'.tr,
                      height: 50,
                      width: 400,
                      child: controller.loading.value
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                          : null,
                    )),
                    SizedBox(height: 10),
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
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
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
      showErrorDialog(Get.context!, 'Email and password cannot be empty');
      return;
    }

    controller.loading.value = true; // Start loading
    await controller.loginOnClick();
    controller.loading.value = false; // Stop loading

    if (controller.loginStatus.value) {
      showSuccessDialog(Get.context!, 'Login successful');
    } else {
      showErrorDialog(Get.context!, controller.message.value);
      print('Error here: ${controller.message.value}');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error',style: TextStyle(color:Colors.black),),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:  Theme.of(context)
              .colorScheme
              .onBackground
              .withOpacity(0.5),
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
