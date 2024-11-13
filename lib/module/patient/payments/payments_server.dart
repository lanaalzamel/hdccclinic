import 'dart:convert';

import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import '../../../config/server_config.dart';
import '../../../models/payments_model.dart';
import 'package:http/http.dart' as http;
class PaymentService extends GetxService {
  Future<List<Invoice>> fetchInvoice(int patientId) async {
    print("Fetching payments for patient ID: $patientId");
    var url = Uri.parse(
        '${ServerConfig.domainNameServer}${ServerConfig.payments(patientId)}');

    print('Requesting URL: $url');

    var response = await http.get(url, headers: {'Accept': 'application/json'});
    print('Response received with status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Invoice.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load invoices');
    }
  }
}
