import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../config/user_info.dart';
import '../../models/patient.dart';
import '../../models/user.dart';
import '../../native_service/secure_storage.dart';

class LoginService {
  var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.loginpatient);
  var token;
  var message;
  String? _firebaseToken;

  // Getter for Firebase token (no longer used)
  String? get firebaseToken => _firebaseToken;

  Future<bool> login(User1 user, bool saveToken) async {
    try {
      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': user.email,
          'Password': user.password,
        }),
      );
      print(';;;;;;;;;;;;;;;;;;;;;;;;;;;;');
print(response.body);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        message = jsonResponse['message'];

        var patientJson = jsonResponse['patient'];
        var medicalRecordJson = jsonResponse['medical_record'];

        if (patientJson == null) {
          print('Error: Patient information is null');
          return false;
        }

        // Commenting out all Firebase token-related code
        // if (firebaseToken != null) {
        //   // Sign in with Firebase using the custom token
        //   await FirebaseAuth.instance.signInWithCustomToken(firebaseToken!);
        //   print("Firebase Authentication successful");
        // } else {
        //   print("Error: Firebase token is null");
        //   return false;
        // }

        // Get the token from the patient object
        token = patientJson['api_token'];
        print(token);
        if (token == null) {
          print('Error: Token is null');
          return false;
        }
        _firebaseToken = jsonResponse['firebase_token'];
        Securestorage storage = Securestorage();

        if (saveToken) {
          // Save token to device
          await storage.save('token', token);
          var patientId = patientJson['id'];
          await storage.save('patient_id', patientId.toString());
        }

        Patient patient = Patient.fromJson(patientJson);
        if (medicalRecordJson != null) {
          MedicalRecord medicalRecord = MedicalRecord.fromJson(medicalRecordJson);
          patient = patient.copyWith(medicalRecord: medicalRecord);
          await storage.saveMedicalRecord(medicalRecord); // Save medical record separately
        }
        Userinformation.USER_TOKEN = token;
        Userinformation.id = patient.id;
        print('Token and Patient information stored correctly');

        await storage.saveTokenAndUserId(token, patient.id.toString());
        await storage.savePatient(patient);

        // Verify storage
        String? storedToken = await storage.read('token');
        Patient? storedPatient = await storage.getPatient();
        print('Stored Token: $storedToken');
        print('Stored Patient: ${storedPatient?.toJson()}');

        if (storedToken == token && storedPatient != null && storedPatient.id == patient.id) {
          print('Token and Patient information stored correctly');
          // Navigate to home page after successful login
          Get.offNamed('/navigation');
          return true;
        } else {
          print('Error storing Token and Patient information');
          return false;
        }
      }else if (response.statusCode == 401) {
        var jsonResponse = jsonDecode(response.body);
        message = jsonResponse['error']; // Set message for 401 errors
        print('Error: ${message}');
        return false;
      }else if (response.statusCode == 422) {
        var jsonResponse = jsonDecode(response.body);
        // Check for the specific error structure
        if (jsonResponse.containsKey('error')) {
          message = jsonResponse['error']; // Correctly set the error message
        } else if (jsonResponse['errors'] != null) {
          message = jsonResponse['errors'].values.join('\n');
        } else {
          message = 'Validation error occurred'; // Generic error message
        }
        print('Validation Error: ${message}');
        return false;
      }  else {
        print('Server error');
        return false;
      }
    } catch (e) {
      print('Exception caught: $e');
      return false;
    }
  }
}
