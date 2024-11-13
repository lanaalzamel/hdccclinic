import 'package:hive/hive.dart';

part 'show_doctors.g.dart';  // Ensure this part directive is correct

@HiveType(typeId: 2)  // Unique typeId for this model
class Doctors {
  @HiveField(0)
  int id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String? phone;

  @HiveField(4)
  String? specialization;

  @HiveField(5)
  String? startWork;

  @HiveField(6)
  String? finishWork;

  @HiveField(7)
  String? photo;

  @HiveField(8)
  String? email;

  @HiveField(9)
  String? password;

  @HiveField(10)
  String? birthday;

  @HiveField(11)
  String? collageDegree;

  @HiveField(12)
  String? createdAt;

  @HiveField(13)
  String? updatedAt;

  Doctors({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.specialization,
    this.startWork,
    this.finishWork,
    this.photo,
    this.email,
    this.password,
    this.birthday,
    this.collageDegree,
    this.createdAt,
    this.updatedAt,
  });

  factory Doctors.fromJson(Map<String, dynamic> json) {
    return Doctors(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      specialization: json['specialization'],
      startWork: json['start_work'],
      finishWork: json['finish_work'],
      photo: json['photo'],
      email: json['email'],
      password: json['password'],
      birthday: json['birthday'],
      collageDegree: json['collage_degree'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'specialization': specialization,
      'start_work': startWork,
      'finish_work': finishWork,
      'photo': photo,
      'email': email,
      'password': password,
      'birthday': birthday,
      'collage_degree': collageDegree,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
