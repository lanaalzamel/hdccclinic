import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../config/user_info.dart';
import '../module/lab/completed_list/completed_list.dart';
import '../module/lab/lab_home/lab_home.dart';
import '../module/lab/settings.dart';
import '../module/patient/chat/chat_list_screen.dart';
import '../module/patient/home/home_view.dart';
import '../module/patient/patient_profile/patient_profile.dart';
import '../test.dart';
import '../translation/languages_controller.dart';

class NavigationMenuLab extends StatelessWidget {
  const NavigationMenuLab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languagesController = Get.find<LanguagesController>();
    final controller = Get.put(NavigationControllerLab());

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20))
          ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Obx(
              () => BottomNavigationBar(
                selectedItemColor:
                    Theme.of(context).primaryColor.withOpacity(0.7),
                unselectedItemColor: Colors.grey,
                currentIndex: controller.selectedIndex.value,
                onTap: (index) => controller.selectedIndex.value = index,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.home),
                    label: languagesController.getTranslation('Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.rectangle_grid_1x2),
                    label: languagesController.getTranslation('request'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Iconsax.setting),
                    label: languagesController.getTranslation('Settings'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationControllerLab extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    LabHome(),
    CompletedList(),
    Settings(),
  ];
}
