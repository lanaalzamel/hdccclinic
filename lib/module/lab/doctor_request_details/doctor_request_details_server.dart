import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hdccapp/config/server_config.dart';
import 'package:hdccapp/models/update_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DoctorRequestDetailsServer {
  var message;

  Future<bool> updateRequest(int labId, Requestmodel request, File image) async {
    try {
      var url = Uri.parse(ServerConfig.domainNameServer + ServerConfig.UpdateRequest(labId));
      print('Request URL: $url');

      var requestMultipart = http.MultipartRequest('POST', url);
      requestMultipart.fields['cost'] = request.cost.toString();
      requestMultipart.fields['delivery_date'] = request.deliveryDate?.toIso8601String().split('T')[0] ?? '';

      // Add image file to the request
      if (image.existsSync()) {
        requestMultipart.files.add(await http.MultipartFile.fromPath('order_image', image.path));
      }

      var response = await requestMultipart.send();
      var responseString = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseString');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseString);
        message = jsonResponse['message'];
        return true;
      } else {
        var jsonResponse = jsonDecode(responseString);
        message = jsonResponse['error'];
        return false;
      }
    } catch (e) {
      print('Error in updateRequest: $e');
      message = 'Error in updateRequest: $e';
      return false;
    }
  }
}
