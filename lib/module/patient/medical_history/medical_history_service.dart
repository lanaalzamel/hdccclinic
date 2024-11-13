// services/medical_history_service.dart

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../config/server_config.dart';
import '../../../models/medical_histort_model.dart';

class MedicalHistoryService extends GetxService {


// services/medical_history_service.dart

  Future<List<MedicalHistory>> fetchMedicalHistory(int patientId) async {
    print("Fetching medical history for patient ID: $patientId");
    var url = Uri.parse(
        '${ServerConfig.domainNameServer}${ServerConfig.medical_history(patientId)}');

    print('Requesting URL: $url');  // Debug print to check URL

    try {
      var response =
      await http.get(url, headers: {'Accept': 'application/json'});

      print('Response received with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => MedicalHistory.fromJson(item)).toList();
      } else {
        print('Error: Failed to load medical history with status code ${response.statusCode}');
        throw Exception('Failed to load medical history');
      }
    } catch (e) {
      print('Exception caught: $e');
      throw Exception('Failed to fetch medical history due to network error.');
    }
  }

}
