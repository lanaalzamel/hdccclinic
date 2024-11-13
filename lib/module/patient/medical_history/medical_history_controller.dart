import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../config/user_info.dart';
import '../../../models/medical_histort_model.dart';
import 'medical_history_service.dart';
import 'package:open_file/open_file.dart';

class MedicalHistoryController extends GetxController {
  final MedicalHistoryService medicalHistoryService;
  var medicalHistoryList = <MedicalHistory>[].obs;
  var filteredMedicalHistoryList = <MedicalHistory>[].obs;
  var isLoading = true.obs;
  var selectedDateRange = 'all'.obs;

  MedicalHistoryController(this.medicalHistoryService);

  @override
  void onInit() {
    super.onInit();
    fetchMedicalHistory(Userinformation.id); // Adjust ID as necessary
  }

  void fetchMedicalHistory(int patientId) async {
    try {
      isLoading(true);
      var histories = await medicalHistoryService.fetchMedicalHistory(patientId);
      medicalHistoryList.value = histories;
      filteredMedicalHistoryList.value = histories;  // Initialize filtered list
    } catch (e) {
      print('Error fetching medical history: $e');
    } finally {
      isLoading(false);
    }
  }

  // Filter Medical History by search query
  void filterMedicalHistory(String query) {
    if (query.isEmpty) {
      filteredMedicalHistoryList.value = medicalHistoryList;
    } else {
      filteredMedicalHistoryList.value = medicalHistoryList
          .where((history) =>
      history.diagnosis.toLowerCase().contains(query.toLowerCase()) ||
          history.treatment.toLowerCase().contains(query.toLowerCase()) ||
          history.doctorName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Set the selected date range
  void setSelectedDateRange(String newValue) {
    selectedDateRange.value = newValue;
  }

// Filter Medical History by date range
  void filterByPredefinedDateRange(String range) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (range) {
      case 'Last 7 days':
        startDate = now.subtract(Duration(days: 7));
        break;
      case 'Last 2 months':
        startDate = DateTime(now.year, now.month - 2, now.day);
        break;
      case 'Last year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      case 'all':
        startDate = DateTime(1900); // Use an old date to include all records
        break;
      default:
        startDate = now; // Default to now for safety
    }

    filteredMedicalHistoryList.value = medicalHistoryList
        .where((history) => DateTime.parse(history.date).isAfter(startDate))
        .toList();
  }


  Future<void> downloadMedicalHistory() async {
    // Check and request storage permissions
    bool permissionGranted = await _requestStoragePermission();
    if (!permissionGranted) {
      Get.snackbar("Permission Denied", "Storage permission is required to save the file.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Define the Downloads directory path
    Directory downloadsDirectory = Directory('/storage/emulated/0/Download');

    // Check if the directory exists, if not create it
    if (!downloadsDirectory.existsSync()) {
      try {
        downloadsDirectory.createSync(recursive: true);
      } catch (e) {
        Get.snackbar("Error", "Failed to create the Downloads directory.",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
    }

    // Define the file path within the Downloads directory
    final path = "${downloadsDirectory.path}/medical_history.csv";
    final file = File(path);

    // Create CSV content
    List<List<String>> rows = [];
    rows.add(["Date", "Diagnosis", "Treatment", "Doctor Name", "Notes"]);

    for (var history in filteredMedicalHistoryList) {
      rows.add([
        history.date,
        history.diagnosis,
        history.treatment,
        history.doctorName,
        history.notes.isNotEmpty ? history.notes : "No notes",
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    print("Storage Permission Status: ${await Permission.storage.status}");
    print("Manage External Storage Permission Status: ${await Permission.manageExternalStorage.status}");

    // Write the CSV file
    try {
      await file.writeAsString(csv);
      // Success message
      Get.snackbar("Download Complete", "Medical history saved to ${file.path}",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Failed to save the file. Error: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }






  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 11 and above (API level 30+)
      if (await Permission.manageExternalStorage.isDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        // Request "Manage External Storage" permission
        var status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      }

      // Check if the storage permission is granted
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        return result.isGranted;
      }
    }
    return true; // If platform is not Android or permissions are already granted
  }



}