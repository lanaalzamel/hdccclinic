import 'package:get/get.dart';
import '../../models/user.dart';
import 'login_service.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var loginStatus = false.obs;
  var message = ''.obs;
  var checkBoxStatus = false.obs;
  var selectedRole = 'patient'.obs;
  var isPasswordVisible = false.obs;
  var loading = false.obs; // Add loading state

  var emailError = ''.obs;
  var passwordError = ''.obs;

  late LoginService service;

  @override
  void onInit() {
    super.onInit();
    service = LoginService();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changeCheckBox() {
    checkBoxStatus.value = !checkBoxStatus.value;
  }

  void setSelectedRole(String role) {
    selectedRole.value = role;
    update();
  }

  bool validateInputs() {
    bool isValid = true;
    if (email.value.isEmpty) {
      emailError.value = 'Email cannot be empty';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (password.value.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  Future<void> loginOnClick() async {
    if (!validateInputs()) {
      return;
    }

    loading.value = true; // Start loading
    User1 user = User1(
      email: email.value,
      password: password.value,
    );
    loginStatus.value = await service.login(user, checkBoxStatus.value);

    if (service.message is List) {
      String temp = '';
      for (String s in service.message) {
        temp += s + '\n';
      }
      message.value = temp;
    } else if (service.message is String) {
      message.value = service.message;
    } else {
      message.value = 'Unknown error occurred';
    }

    loading.value = false; // Stop loading
  }
}
