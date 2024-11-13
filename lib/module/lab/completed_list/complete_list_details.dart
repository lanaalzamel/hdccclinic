import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../utlis/global_color.dart';
import '../../../models/updated_request_model.dart';

class CompleteListDetailsPage extends StatelessWidget {
  final UpdateRequest request;
  CompleteListDetailsPage({required this.request});

  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

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
        backgroundColor: GlobalColors.mainColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailContainer(context, _buildRequestDetails(context)),
              SizedBox(height: 15),
              _buildDetailContainer(context, _buildCostRow('Cost:'.tr, request.cost)),
              SizedBox(height: 15),
              _buildDetailContainer(context, _buildImageSection(context)),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to create a container around detail sections
  Widget _buildDetailContainer(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: GlobalColors.mainColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: child,
    );
  }

  // Build the request details similar to the previous page design
  Widget _buildRequestDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Doctor:'.tr, request.doctorName),
        _buildDetailRow('Patient:'.tr, request.patientName),
        _buildDetailRow('Medical Tech:'.tr, request.medicalTechName),
        _buildDetailRow('Request Type:'.tr, request.requestType),
        _buildDetailRow('Color:'.tr, request.color),
        _buildDetailRow('Request Date:'.tr, dateFormatter.format(request.requestDate)),
        _buildDetailRow('Delivery Date:'.tr, dateFormatter.format(request.deliveryDate)),
      ],
    );
  }

  // Build the detail rows (same as in the previous class)
  Widget _buildDetailRow(String label, String value) {
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
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the cost row with special emphasis (similar to the previous class)
  Widget _buildCostRow(String label, num cost,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey
          ),
        ),
        Text(
          '\$${cost.toString()}',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  // Build the image section similar to the previous class
  Widget _buildImageSection(BuildContext context) {
    if (request.imagePath != null && request.imagePath!.isNotEmpty) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            _replaceLocalhost(request.imagePath!),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'Image could not load.'.tr,
                style: TextStyle(fontFamily: 'Poppins'),
              );
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          'No Image Available'.tr,
          style: TextStyle(fontFamily: 'Poppins'),
        ),
      );
    }
  }

  // Helper method to replace localhost with emulator IP
  String _replaceLocalhost(String imagePath) {
    return imagePath.replaceAll('127.0.0.1:8000', '10.0.2.2:8000');
  }
}
