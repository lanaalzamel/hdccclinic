class Patient {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String address;
  final String treatmentPlan;
  final String avatar;
  final String email;
  final String? recommendation;
  final String? code;
  final String apiToken;
  final MedicalRecord? medicalRecord;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.address,
    required this.treatmentPlan,
    required this.avatar,
    required this.email,
    this.code,
    this.recommendation,
    required this.apiToken,
    this.medicalRecord,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['First_name'] ?? '',
      lastName: json['Last_name'] ?? '',
      phoneNumber: json['Phone_number'] ?? '',
      address: json['Address'] ?? '',
      treatmentPlan: json['Treatment_plan'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] ?? '',
      code: json['code'],
      recommendation: json['recommendation'],
      apiToken: json['api_token'] ?? '',
      medicalRecord: json['medical_record'] != null ? MedicalRecord.fromJson(json['medical_record']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'First_name': firstName,
      'Last_name': lastName,
      'Phone_number': phoneNumber,
      'Address': address,
      'Treatment_plan': treatmentPlan,
      'avatar': avatar,
      'email': email,
      'code': code,
      'recommendation': recommendation,
      'api_token': apiToken,
      'medical_record': medicalRecord?.toJson(),
    };
  }

  Patient copyWith({MedicalRecord? medicalRecord}) {
    return Patient(
      id: this.id,
      firstName: this.firstName,
      lastName: this.lastName,
      phoneNumber: this.phoneNumber,
      address: this.address,
      treatmentPlan: this.treatmentPlan,
      avatar: this.avatar,
      email: this.email,
      code: this.code,
      recommendation: this.recommendation,
      apiToken: this.apiToken,
      medicalRecord: medicalRecord ?? this.medicalRecord,
    );
  }
}
class MedicalRecord {
  final String diagnosis;
  final String photos;

  MedicalRecord({
    required this.diagnosis,
    required this.photos,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      diagnosis: json['Diagnosis'] ?? '',
      photos: json['photos'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Diagnosis': diagnosis,
      'photos': photos,
    };
  }
}
