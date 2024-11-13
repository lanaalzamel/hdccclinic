import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../models/patient.dart';
import '../models/show_doctors.dart';

import '../models/user_lab.dart'; // Ensure you import Medicaltech model

  class Securestorage {
  final storage = FlutterSecureStorage();

  Future<void> save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }
  // Read from secure storage
  Future<String?> read1({required String key}) async {
    return await storage.read(key: key);
  }
  // Write to secure storage
  Future<void> write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }
  Future<void> saveTokenAndUserId(String token, String userId) async {
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'user_id', value: userId);
  }

  Future<Map<String, String?>> readTokenAndUserId() async {
    String? token = await storage.read(key: 'token');
    String? userId = await storage.read(key: 'user_id');
    return {'token': token, 'user_id': userId};
  }

  Future<void> saveAppointment(Doctors doctors) async {
    String jsonString = jsonEncode(doctors.toJson());
    await storage.write(key: 'doctors', value: jsonString);
  }

  Future<Doctors?> getAppointment() async {
    try {
      String? jsonString = await storage.read(key: 'doctors');
      if (jsonString == null) {
        return null;
      }
      Map<String, dynamic> json = jsonDecode(jsonString);
      return Doctors.fromJson(json);
    } catch (e) {
      print('Error reading appointment: $e');
      return null;
    }
  }

  Future<void> deleteAppointment() async {
    await storage.delete(key: 'doctors');
  }

  // Patient methods
  Future<void> savePatient(Patient patient) async {
    String jsonString = jsonEncode(patient.toJson());
    await storage.write(key: 'patient', value: jsonString);
  }

  Future<Patient?> getPatient() async {
    String? jsonString = await storage.read(key: 'patient');
    if (jsonString == null) {
      return null;
    }


    Map<String, dynamic> json = jsonDecode(jsonString);


    Patient patient = Patient.fromJson(json);


    // Retrieve medical record separately
    MedicalRecord? medicalRecord = await getMedicalRecord();
    if (medicalRecord != null) {
      patient = patient.copyWith(medicalRecord: medicalRecord);
    }

    return patient;
  }


  Future<void> deletePatient() async {
    await storage.delete(key: 'patient');
  }

  // Medical record methods
  Future<void> saveMedicalRecord(MedicalRecord medicalRecord) async {
    String jsonString = jsonEncode(medicalRecord.toJson());
    await storage.write(key: 'medical_record', value: jsonString);
  }

  Future<MedicalRecord?> getMedicalRecord() async {
    String? jsonString = await storage.read(key: 'medical_record');
    if (jsonString == null) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);
    return MedicalRecord.fromJson(json);
  }

  Future<void> deleteMedicalRecord() async {
    await storage.delete(key: 'medical_record');
  }

  // Medicaltech methods
  Future<void> saveMedicaltech(Medicaltech medicaltech) async {
    String jsonString = jsonEncode(medicaltech.toJson());
    await storage.write(key: 'medicaltech', value: jsonString);
  }

  Future<Medicaltech?> getMedicaltech() async {
    String? jsonString = await storage.read(key: 'medicaltech');
    if (jsonString == null) {
      return null;
    }
    Map<String, dynamic> json = jsonDecode(jsonString);
    return Medicaltech.fromJson(json);
  }

  Future<void> deleteMedicaltech() async {
    await storage.delete(key: 'medicaltech');
  }

  Future<void> setThemeMode(bool isDarkMode) async {
    await storage.write(key: 'isDarkMode', value: isDarkMode.toString());
  }

  Future<bool> getThemeMode() async {
    String? value = await storage.read(key: 'isDarkMode');
    return value != null && value.toLowerCase() == 'true';
  }
  static const _keyLanguage = 'selectedLanguage';
  Future<void> saveLanguage(String languageCode) async {
    await storage.write(key: _keyLanguage, value: languageCode);
  }

  Future<String?> getLanguage() async {
    return await storage.read(key: _keyLanguage);
  }

  }
