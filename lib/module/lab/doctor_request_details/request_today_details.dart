import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hdccapp/module/lab/lab_home/lab_home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../Widgets/button.dart';
import '../../../models/today_request_model.dart';
import '../../../services/firebase_service.dart';
import '../../../services/image_service.dart';
import '../../../utlis/global_color.dart';
import '../lab_home/new_lab_request_list/new_lab_request_list_controller.dart';
import 'doctor_request_details_controller.dart';

class RequesTodayDetailsPage extends StatelessWidget {
  final TodayRequest request;
  final TodayLabRequestListController _labRequestListController = Get.find<TodayLabRequestListController>();

  RequesTodayDetailsPage({Key? key, required this.request}) : super(key: key) {
    // Mark the request as opened when the page is opened
    _labRequestListController.markRequestAsOpened(request.id);
  }

  final RequestController _requestController = Get.put(RequestController());
  final ImageService _imageService = ImageService();
  final ImagePicker _picker = ImagePicker();

  bool canUpdateRequest() {
    return _requestController.cost.value > 0 &&
        _requestController.deliveryDate.value != null &&
        _requestController.selectedImages.isNotEmpty;
  }

  String _replaceLocalhost(String imagePath) {
    return imagePath.replaceAll('127.0.0.1:8000', '192.168.1.4:8000');
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage(imageQuality: 80);
      if (selectedImages != null) {
        _requestController.clearImages();
        _requestController.selectedImages.assignAll(selectedImages);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _resetState() {
    _requestController.clearImages();
    _requestController.cost.value = 0;
  }

  Future<void> _selectDeliveryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      _requestController.deliveryDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Details'.tr,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1?.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRequestDetails(context),
              const SizedBox(height: 15),
              _buildCostInput(context),
              const SizedBox(height: 15),
              _buildDeliveryDateInput(context),
              const SizedBox(height: 20),
              _buildSelectedImages(context),
              const SizedBox(height: 20),
              _buildUpdateButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestDetails(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextRow(context, 'Doctor:'.tr, request.doctorName),
          _buildTextRow(context, 'Patient:'.tr, request.patientName),
          _buildTextRow(context, 'Date:'.tr, request.requestDate.toLocal().toString().split(' ')[0]),
          _buildTextRow(context, 'Type:'.tr, request.requestType),
          _buildTextRow(context, 'Color:'.tr, request.color),
          if (request.imagePath != null && request.imagePath!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(_replaceLocalhost(request.imagePath!)),
            ),
        ],
      ),
    );
  }

  Widget _buildTextRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostInput(BuildContext context) {
    return TextField(
      onChanged: (value) {
        _requestController.cost.value = int.tryParse(value) ?? 0;
      },
      decoration: InputDecoration(
        labelText: 'Cost'.tr,
        labelStyle: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyText1?.color),
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: GlobalColors.mainColor),
        ),
      ),
      keyboardType: TextInputType.number,
      style: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyText1?.color),
    );
  }

  Widget _buildDeliveryDateInput(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDeliveryDate(context),
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(
            text: _requestController.deliveryDate.value != null
                ? DateFormat('yyyy-MM-dd').format(_requestController.deliveryDate.value!)
                : '',
          ),
          decoration: InputDecoration(
            labelText: 'Delivery Date'.tr,
            labelStyle: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyText1?.color),
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GlobalColors.mainColor),
            ),
          ),
          keyboardType: TextInputType.datetime,
          style: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyText1?.color),
        ),
      ),
    );
  }

  Widget _buildSelectedImages(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          ElevatedButton(
            onPressed: _pickImages,
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
            child: Text(
              'Pick Image'.tr,
              style: TextStyle(fontFamily: 'Poppins', color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ),
          const SizedBox(height: 10),
          if (_requestController.selectedImages.isNotEmpty)
            Wrap(
              spacing: 10,
              children: _requestController.selectedImages.map((image) {
                return Image.file(
                  File(image.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
        ],
      );
    });
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Obx(() {
      return Center(
        child: ElevatedButton(
          onPressed: canUpdateRequest() ? () => onClickUpdateRequest(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: canUpdateRequest() ? Theme.of(context).primaryColor : Colors.grey,
          ),
          child: Text(
            'Update'.tr,
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
          ),
        ),
      );
    });
  }

  void onClickUpdateRequest(BuildContext context) async {
    try {
      if (_requestController.selectedImages.isEmpty) {
        _showDialog(context, 'Error', 'No images selected.');
        return;
      }

      Get.dialog(Center(child: CircularProgressIndicator()));

      File imageFile = File(_requestController.selectedImages[0].path);
      await _requestController.updateOnClick(request.id, imageFile);

      Get.back();

      if (_requestController.updateStatus.value) {
        _showDialog(context, 'Success', 'Update successful.');
        _resetState();
        Future.delayed(const Duration(seconds: 1), () {
          Get.toNamed('/navigationlab');
        });
      } else {
        _showDialog(context, 'Error', 'There was an error updating the request.');
      }
    } catch (e) {
      Get.back();
      _showDialog(context, 'Error', 'An unexpected error occurred.');
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
