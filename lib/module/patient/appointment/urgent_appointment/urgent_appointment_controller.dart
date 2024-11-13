import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hdccapp/module/patient/appointment/urgent_appointment/urgent_appointment_service.dart';
import '../../../../config/user_info.dart';
import '../../../../models/emergency_model.dart';
import '../../../../models/emergency_response .dart';
import '../../../../models/urgent_appointment_model.dart';
import 'emergency_steps.dart';

class UrgentAppointmentController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emergencyController = TextEditingController();

  final UrgentAppointmentService emergencyService = UrgentAppointmentService();

  Future<void> sendUrgentAppointment(BuildContext context, EmergencyGuidance selectedEmergency) async {
    if (formKey.currentState!.validate()) {
      int patientId = Userinformation.id;
      if (patientId == -1) {
        _showDialog(context, 'Error', 'Patient ID not found', false);
        return;
      }

      final emergency = Emergency(
        patientId: patientId.toString(),
        reason: emergencyController.text,
      );

      EmergencyResponse? response = await emergencyService.sendEmergency(emergency);

      if (response != null) {
        _showDialog(context, 'Success'.tr, 'Appointment request sent successfully'.tr, true, () {
          // Navigate to EmergencyGuidanceScreen only after successful booking
          Get.to(() => EmergencyGuidanceScreen(emergency: selectedEmergency));
        });
      } else {
        _showDialog(context, 'Error'.tr, emergencyService.message ?? 'An unexpected error occurred'.tr, false);
      }
    }
  }

  void _showDialog(BuildContext context, String title, String message, bool success, [VoidCallback? onSuccess]) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.cancel,
              color: success ? Colors.greenAccent : Colors.redAccent,
              size: 60,
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: success ? Colors.black : Colors.redAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                if (success && onSuccess != null) {
                  onSuccess();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: success ? Colors.greenAccent : Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}

