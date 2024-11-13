import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/server_config.dart';
import '../../../config/user_info.dart';
import '../../../models/user.dart';
import '../../../models/user_lab.dart';
import '../../../native_service/secure_storage.dart';

class LabLoginService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.loginlaboratory);
 var token;
  late dynamic message=''; // Initialize with dynamic type to handle various data types

  Future<bool> login(User1 user, bool saveToken) async {
    try {
      var response = await http.post(
        url,
        headers: {'Accept': 'application/json'},
        body: {
          'email': user.email,
          'password': user.password,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
          message = jsonResponse['message'];
        var medicaltechJson = jsonResponse['medicaltech'];

        if (medicaltechJson == null) {
          print('Error: Lab information is null');
          return false;
        }

        token = medicaltechJson['api_token'];
        print(token);
        if (token == null) {
          print('Error: Token is null');
          return false;
        }

        Securestorage storage = Securestorage();

        if (saveToken) {
          await storage.save('token', token);
          var medicaltechId = medicaltechJson['id'];
          await storage.save('medicaltech_id', medicaltechId.toString());
        }


        Medicaltech medicaltech = Medicaltech.fromJson(medicaltechJson);

        // Store user information in a UserInfo class or similar mechanism
        Userinformation.USER_TOKEN = token;
        Userinformation.id = medicaltech.id;
        print('ffffffffffffffffffffffffff');
        print( Userinformation.id = medicaltech.id);
        print('ffffffffffffffffffffffffffffffff');
        await storage.saveTokenAndUserId(token, medicaltech.id.toString());
        await storage.saveMedicaltech(medicaltech);

        // Verify if the stored token and medicaltech match the retrieved values
        String? storedToken = await storage.read('token');
        Medicaltech? storedMedicaltech = await storage.getMedicaltech();
        if (storedToken == token && storedMedicaltech != null && storedMedicaltech.id == medicaltech.id) {
          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 401) {

        var jsonResponse = jsonDecode(response.body);
        message = jsonResponse['error'];// Default message if 'error' field is not present
        return false;
      } else if (response.statusCode == 422) {
        var jsonResponse = jsonDecode(response.body);
        message = jsonResponse['errors'];// Default message if 'errors' field is not present
        return false;
      } else {
        print('Server error');
         // Handle unknown errors
        return false;
      }
    } catch (e) {
      print('Exception caught: $e');

      return false;
    }
  }
}
