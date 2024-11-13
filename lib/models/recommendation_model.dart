import 'dart:convert';

class Doctor {
  final String name;
  final String specialization;
  final String? photo;

  Doctor({required this.name, required this.specialization, this.photo});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['name'],
      specialization: json['specialization'],
      photo: json['photo'],
    );
  }
}

class Recommendation {
  final String recommendation;
  final Doctor doctor;

  Recommendation({required this.recommendation, required this.doctor});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      recommendation: json['recommendation'],
      doctor: Doctor.fromJson(json['doctor']),
    );
  }
}

List<Recommendation> parseRecommendations(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Recommendation>((json) => Recommendation.fromJson(json)).toList();
}
