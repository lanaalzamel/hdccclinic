// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class onBoarding extends StatefulWidget {
  State<onBoarding> createState() => _onBoardingState();
}

class _onBoardingState extends State<onBoarding> {
  late PageController _pageController;
  int _PageIndex = 0;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'skip'.tr,
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ],
                ),
                onTap: () {
                  Get.toNamed('/login');
                },
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: demo_data.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _PageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => Onboardingcontent(
                    image: demo_data[index].image,
                    title: demo_data[index].title,
                    description: demo_data[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(
                    demo_data.length,
                        (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Dotindictor(
                        isActive: index == _PageIndex,
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      if (_PageIndex == demo_data.length - 1) {
                        Get.toNamed('/login');
                      }
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint);
                    },
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 50,
                      width: (_PageIndex == (demo_data.length - 1)) ? 150 : 75,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(35)),
                      child: (_PageIndex == (demo_data.length - 1))
                          ? Text(
                        "Get Started".tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      )
                          : Icon(
                        Icons.navigate_next,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Dotindictor extends StatelessWidget {
  const Dotindictor({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isActive ? 20 : 6,
      height: 4,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.blue.withOpacity(0.4),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demo_data = [
  Onboard(
      image: 'images/svgs/onboarding/undraw_connected_world_wuay.png',
      title: 'Find \nyour destination'.tr,
      description:
      ' Choose your destination, plan your trip. \nPick your best place to your holiday,'.tr),
  Onboard(
      image: 'images/svgs/onboarding/undraw_Booking_re_gw4j (1).png',
      title: 'Select \nthe Date'.tr,
      description:
      'Select the day, book your ticket. we give\n the best price for you.'.tr),
  Onboard(
      image: 'images/svgs/onboarding/undraw_Through_the_desert_re_1q2x.png',
      title: 'Find \nyour Trip'.tr,
      description:
      'Enjoy your holiday! Take a photo, share to \nthe world and tag us'.tr),
];

class Onboardingcontent extends StatelessWidget {
  const Onboardingcontent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 250,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.blue[300],
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
      ],
    );
  }
}
