import 'package:get/get.dart';
import 'package:hdccapp/module/resetpassword/resetpassword_service.dart';

import '../../models/user.dart';

class reSetPasswordController extends GetxController {
  var resetpassword = '';
  var password = '';
  var ResetPasswordStatus = false;
  var message = '';
  ResetPasswordService service = ResetPasswordService();

  Future<void> restPasswordOnClick() async {
    User1 user = User1(
      resetpassword: resetpassword,
      password: password,
    );

    ResetPasswordStatus = await service.register(user);
    if (!ResetPasswordStatus) {
      print('there is an error: $message');
    }
  }
}
