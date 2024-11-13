import 'package:get/get.dart';
import 'package:hdccapp/module/validate_code/validate_code_service.dart';


import '../../models/code.dart';

class verifyCodeController extends GetxController {
  var code = '';
  var checkCodeStatuse = false;
  var message;
  VerifyCodeService service = VerifyCodeService();
  Future<void> resetPasswordOnClick(Code l) async {
    Code code1 = Code(
      code: l.code.toString(),
    );
    checkCodeStatuse= await service.VerifyCode(code1);
    message = service.message;
    if (message is List) {
      String temp = '';
      for (String s in message) temp += s + '\n';
      message = temp;
    }
  }
}
