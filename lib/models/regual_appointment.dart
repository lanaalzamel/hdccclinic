class Appointment {
  String message;
  AppointmentClass appointment;

  Appointment({
    required this.message,
    required this.appointment,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      message: json['message'],
      appointment: AppointmentClass.fromJson(json['appointment']),
    );
  }
}

class AppointmentClass {
  int doctorId;
  String patientId;
  DateTime date;
  String time;
  bool isBooked;
  String status;
  int id;

  AppointmentClass({
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.time,
    required this.isBooked,
    required this.status,
    required this.id,
  });

  factory AppointmentClass.fromJson(Map<String, dynamic> json) {
    return AppointmentClass(
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      isBooked: json['is_booked'],
      status: json['status'],
      id: json['id'],
    );
  }
}
