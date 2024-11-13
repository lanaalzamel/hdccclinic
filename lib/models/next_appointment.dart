class NextAppointment {
  int appointmentId;
  DateTime appointmentDate;
  Doctor doctor;

  NextAppointment({
    required this.appointmentId,
    required this.appointmentDate,
    required this.doctor,
  });

  factory NextAppointment.fromJson(Map<String, dynamic> json) {
    // Parse the date and time separately, then combine them into a single DateTime object
    String dateStr = json['date'] ?? '';
    String timeStr = json['time'] ?? '';

    DateTime appointmentDate = DateTime.now();
    if (dateStr.isNotEmpty && timeStr.isNotEmpty) {
      appointmentDate = DateTime.parse('$dateStr $timeStr');
    }

    return NextAppointment(
      appointmentId: json['appointment_id'] ?? 0,
      appointmentDate: appointmentDate,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'])
          : Doctor(firstName: '', lastName: '', specialization: '',photo: ''), // Handle null doctor
    );
  }

  Map<String, dynamic> toJson() {
    // Serialize the NextAppointment object to JSON
    return {
      'appointment_id': appointmentId,
      'date': appointmentDate.toIso8601String().split('T')[0], // Extract date part
      'time': appointmentDate.toIso8601String().split('T')[1], // Extract time part
      'doctor': doctor.toJson(),
    };
  }
}

class Doctor {
  String firstName;
  String lastName;
  String specialization;
  String photo;

  Doctor({
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.photo,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    // Parse the doctor details from JSON
    return Doctor(
      firstName: json['first_name'] ?? '', // Provide default value for null
      lastName: json['last_name'] ?? '', // Provide default value for null
      specialization: json['specialization'] ?? '', // Provide default value for null
      photo:json['photo']??'',
    );
  }

  Map<String, dynamic> toJson() {
    // Serialize the Doctor object to JSON
    return {
      'first_name': firstName,
      'last_name': lastName,
      'specialization': specialization,
      'photo': photo,
    };
  }
}
