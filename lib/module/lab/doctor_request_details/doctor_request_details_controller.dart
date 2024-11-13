import 'dart:io';

import 'package:get/get.dart';
import 'package:hdccapp/config/server_config.dart';
import 'package:hdccapp/models/update_request_model.dart';
import 'doctor_request_details_server.dart';
import 'package:image_picker/image_picker.dart';
class RequestController extends GetxController {
  var cost = 0.obs;
  var orderImage = ''.obs;
  Rx<DateTime?> deliveryDate = Rx<DateTime?>(null);
  var message = ''.obs;
  var updateStatus = false.obs;
  var selectedImages = <XFile>[].obs;
  late DoctorRequestDetailsServer service;

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

  void clearImages() {
    selectedImages.clear();
  }

  @override
  void onInit() {
    super.onInit();
    service = DoctorRequestDetailsServer();
  }

  Future<void> updateOnClick(int requestId, File imageFile) async {
    print('Starting updateOnClick');
    try {
      Requestmodel request = Requestmodel(
        cost: cost.value,
        deliveryDate: deliveryDate.value,
      );

      updateStatus.value = await service.updateRequest(requestId, request, imageFile);
      print('Update request completed with status: ${updateStatus.value}');

      if (service.message is List) {
        String temp = '';
        for (String s in service.message) {
          temp += s + '\n';
        }
        message.value = temp;
      } else {
        message.value = service.message;
      }
    } catch (e) {
      print('Error updating request: $e');
      message.value = 'Error updating request: $e';
      updateStatus.value = false;
    }
  }
}
