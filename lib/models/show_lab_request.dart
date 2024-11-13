class LabRequest {
  final int id;
  final String doctorName;
  final String patientName;
  final String medicalTechName;
  final String requestType;
  final String requestDate;
  final String imagePath;
  final String color;
  final dynamic details;

  LabRequest({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.medicalTechName,
    required this.requestType,
    required this.requestDate,
    required this.imagePath,
    required this.color,
    required this.details,
  });

  factory LabRequest.fromJson(Map<String, dynamic> json) {
    return LabRequest(
      id: json['id'],
      doctorName: json['doctor_name'] ?? '',
      patientName: json['patient_name'] ?? '',
      medicalTechName: json['medical_tech_name'] ?? '',
      requestType: json['request_type'] ?? '',
      requestDate: json['request_date'] ?? '',
      imagePath: json['image_path'] ?? '',
      color: json['color'] ?? '',
      details: json['details'],
    );
  }
}
