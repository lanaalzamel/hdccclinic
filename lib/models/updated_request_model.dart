import 'package:flutter/foundation.dart';

class UpdateRequest {
  final int id;
  final String doctorName;
  final String patientName;
  final String medicalTechName;
  final String requestType;
  final DateTime requestDate;
  final String? imagePath;  // Nullable field
  final String color;
  final String details;
  final int cost;
  final DateTime deliveryDate;
  final String? orderImage;  // Nullable field

  UpdateRequest({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.medicalTechName,
    required this.requestType,
    required this.requestDate,
    this.imagePath,  // Nullable
    required this.color,
    required this.details,
    required this.cost,
    required this.deliveryDate,
    this.orderImage,  // Nullable
  });

  factory UpdateRequest.fromJson(Map<String, dynamic> json) {
    return UpdateRequest(
      id: json['id'],
      doctorName: json['doctor_name'] ?? 'N/A',  // Provide default if null
      patientName: json['patient_name'] ?? 'N/A',
      medicalTechName: json['medical_tech_name'] ?? 'N/A',
      requestType: json['request_type'] ?? 'N/A',
      requestDate: DateTime.tryParse(json['request_date']) ?? DateTime.now(),  // Fallback to current date if parsing fails
      imagePath: json['image_path'],  // Nullable
      color: json['color'] ?? 'Unknown',
      details: json['details'] ?? 'No details provided',
      cost: json['cost'] ?? 0,  // Fallback to 0 if cost is null
      deliveryDate: DateTime.tryParse(json['delivery_date']) ?? DateTime.now(),  // Fallback to current date
      orderImage: json['order_image'],  // Nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_name': doctorName,
      'patient_name': patientName,
      'medical_tech_name': medicalTechName,
      'request_type': requestType,
      'request_date': requestDate.toIso8601String(),
      'image_path': imagePath,
      'color': color,
      'details': details,
      'cost': cost,
      'delivery_date': deliveryDate.toIso8601String(),
      'order_image': orderImage,
    };
  }

  static List<UpdateRequest> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => UpdateRequest.fromJson(json)).toList();
  }
}
