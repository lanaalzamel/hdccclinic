import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hdccapp/utlis/global_color.dart';

import '../login/login_view.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.backgroundColor,
      body: Scaffold(
        body: Center(
            child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: 'logo',
            child: Image.asset('assets/images/logo.png'),
          ),
        )),
      ),
    );
  }
}
