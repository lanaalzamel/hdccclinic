import 'package:hive/hive.dart';

part 'chat_model.g.dart';  // This tells Hive to generate the adapter here

@HiveType(typeId: 0)
class Chat {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int patientId;

  @HiveField(2)
  final int doctorId;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final String updatedAt;

  Chat({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Chat from JSON
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
