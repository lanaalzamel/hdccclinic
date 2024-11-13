import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Widgets/custom_button.dart';
import '../../../models/lab_request.dart';
import '../../../services/firebase_service.dart';
import '../../../services/image_service.dart';
import '../../../utlis/global_color.dart';
import 'lab_request_controller.dart';

class completerequestDetail extends StatefulWidget {
  @override
  State<completerequestDetail> createState() => _completerequestDetailState();
}

class _completerequestDetailState extends State<completerequestDetail> {
  final TypePickerController controller = Get.put(TypePickerController());
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _colorGradationController =
      TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final ImageService _imageService = ImageService();

  Future<void> _pickImages() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage(
        imageQuality: 80, // Adjust the quality as needed
      );
      if (selectedImages != null) {
        controller.clearImages();
        controller.selectedImages.addAll(selectedImages);
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _sendDetails() async {
    final labRequest = LabRequestDetails(
      from: 'DR. Lina',
      patientName: 'Lana Alzamel',
      date: '22-Jun-2020',
    );

    final selectedTypes = controller.selectedType;
    final selectedImages =
        controller.selectedImages.map((image) => File(image.path)).toList();
    final colorGradation = _colorGradationController.text;

    // Upload images and get URLs
    List<String> imageUrls = [];
    for (var image in selectedImages) {
      String? imageUrl = await _imageService.uploadImage(image);
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      }
    }

    // Send details to database
    await _firebaseService.sendDetails(
      imageUrls,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: GlobalColors.backgroundColor,
        body: Column(
          children: [
            Container(
              height: 225,
              decoration: BoxDecoration(color: GlobalColors.mainColor),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Request Details:'.tr,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'From: DR. Lina'.tr,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Patient Name: Lana Alzamel'.tr,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Date: 22-Jun-2020'.tr,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Type:'.tr,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: GlobalColors.textColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: controller.requestType.map((type) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(
                                () => Checkbox(
                                  activeColor: GlobalColors.mainColor,
                                  value: controller.selectedType.contains(type),
                                  onChanged: (bool? value) {
                                    if (value != null && value) {
                                      controller.selectedType.add(type);
                                    } else {
                                      controller.selectedType.remove(type);
                                    }
                                  },
                                ),
                              ),
                              Text(
                                type,
                                style: TextStyle(color: GlobalColors.textColor),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Color Gradation:',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: GlobalColors.textColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Color',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: GlobalColors.textColor,
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: TextFormField(
                              controller: _colorGradationController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '3A',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'Pick Images',
                        onPressed: _pickImages,
                      ),
                      SizedBox(height: 10),
                      Obx(
                        () => Wrap(
                          spacing: 10,
                          children: controller.selectedImages.map((image) {
                            return Image.file(
                              File(image.path),
                              width: 100,
                              height: 100,
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        text: 'Send Details',
                        onPressed: _sendDetails,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
