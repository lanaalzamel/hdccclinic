// models/medical_history.dart

class MedicalHistory {
  final int id;
  final int patientId;
  final String diagnosis;
  final String treatment;
  final String doctorName;
  final String date;
  final String notes;
  final String photos;

  MedicalHistory({
    required this.id,
    required this.patientId,
    required this.diagnosis,
    required this.treatment,
    required this.doctorName,
    required this.date,
    required this.notes,
    required this.photos,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      id: json['id'],
      patientId: json['patient_id'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      doctorName: json['doctor_name'],
      date: json['date'],
      notes: json['notes'],
      photos: json['photos'],
    );
  }
}
