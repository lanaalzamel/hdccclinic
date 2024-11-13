class AppointmentByStatus {
  final int id;
  final int doctorId;
  final int patientId;
  final String? type; // Nullable type
  final String? reason; // Nullable reason
  final String status;
  final String date;
  final String time;
  final int isBooked;
  final Doctor doctor;

  AppointmentByStatus({
    required this.id,
    required this.doctorId,
    required this.patientId,
    this.type,
    this.reason,
    required this.status,
    required this.date,
    required this.time,
    required this.isBooked,
    required this.doctor,
  });

  factory AppointmentByStatus.fromJson(Map<String, dynamic> json) {
    return AppointmentByStatus(
      id: json['id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      type: json['type'] ?? '', // Use empty string as default if null
      reason: json['reason'] ?? '', // Use empty string as default if null
      status: json['status'],
      date: json['date'] ?? 'urgent', // Default to "urgent" if date is null
      time: json['time'] ?? '',// Use empty string as default if null (adjust as needed)
      isBooked: json['is_booked'],
      doctor: Doctor.fromJson(json['doctor']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'patient_id': patientId,
      'type': type,
      'reason': reason,
      'status': status,
      'date': date,
      'time': time,
      'is_booked': isBooked,
      'doctor': doctor.toJson(),
    };
  }
}
class Doctor {
  final int id;
  final String firstName;
  final String lastName;
  final String specialization;

  Doctor({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.specialization,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      specialization: json['specialization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'specialization': specialization,
    };
  }
}
