class EmergencyResponse {
  final int doctorId;
  final String patientId;
  final String type;
  final String reason;
  final int id;

  EmergencyResponse({
    required this.doctorId,
    required this.patientId,
    required this.type,
    required this.reason,
    required this.id,
  });

  factory EmergencyResponse.fromJson(Map<String, dynamic> json) {
    return EmergencyResponse(
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      type: json['type'],
      reason: json['reason'],
      id: json['id'],
    );
  }
}
