import 'dart:convert';

class TodayRequest {
  int id;
  String doctorName;
  String patientName;
  String medicalTechName;
  String requestType;
  DateTime requestDate;
  String? imagePath;
  String color;
  dynamic details;

  TodayRequest({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.medicalTechName,
    required this.requestType,
    required this.requestDate,
     this.imagePath,
    required this.color,
    required this.details,
  });

  factory TodayRequest.fromJson(Map<String, dynamic> json) {
    return TodayRequest(
      id: json['id'],
      doctorName: json['doctor_name'],
      patientName: json['patient_name'],
      medicalTechName: json['medical_tech_name'],
      requestType: json['request_type'],
      requestDate: DateTime.parse(json['request_date']),
      imagePath: json['image_path'],
      color: json['color'],
      details: json['details'],
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
    };
  }

  static List<TodayRequest> listFromJson(List<dynamic> json) {
    return json.map((e) => TodayRequest.fromJson(e)).toList();
  }

  static String listToJson(List<TodayRequest> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }
}
