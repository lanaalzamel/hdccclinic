import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../models/user.dart';

import 'login_lab_server.dart';

class LabLoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var loginStatus = false.obs;
  var message = ''.obs;
  var checkBoxStatus = false.obs;
  var selectedRole = 'patient'.obs;  // Default role is patient

  late LabLoginService service;

  @override
  void onInit() {
    super.onInit();
    service = LabLoginService();
  }

  void changeCheckBox() {
    checkBoxStatus.value = !checkBoxStatus.value;
    print('Checkbox status: ${checkBoxStatus.value}');
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
    print('Selected Role: $selectedRole');
    update();
  }

  Future<void> loginLabOnClick() async {
    User1 user = User1(
      email: email.value,
      password: password.value,
    );

    loginStatus.value = await service.login(user, checkBoxStatus.value);

    // Handle message from service
    if (service.message == null) {
      message.value = 'No message received'; // Set default message if null
    } else if (service.message is List) {
      message.value = service.message.join('\n'); // Join list elements with newline
    } else {
      message.value = service.message.toString(); // Convert to string if necessary
    }

    // Example of further handling based on loginStatus
    if (loginStatus.value) {
      EasyLoading.showSuccess('Login successful');
      Get.offNamed('/navigationlab');
    } else {
      EasyLoading.showError('Login failed');
      print('Error message: ${message.value}');
    }
  }
}
