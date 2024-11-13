import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../../../../models/emergency_model.dart';
import '../../../../utlis/global_color.dart';
import 'urgent_appointment_controller.dart';

class UrgentAppointment extends StatefulWidget {
  @override
  _UrgentAppointmentState createState() => _UrgentAppointmentState();
}

class _UrgentAppointmentState extends State<UrgentAppointment> {
  final UrgentAppointmentController appointmentController = Get.put(UrgentAppointmentController());
  EmergencyGuidance? selectedEmergency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: Text(
          'Urgent Appointment'.tr,
          style: TextStyle(
            fontFamily: "Poppins",
            color: GlobalColors.textColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/navigation');
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: appointmentController.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDropdown<String>(
                  hintText: 'Select your emergency'.tr,
                  items: emergencies.map((e) => e.title).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedEmergency = emergencies.firstWhere((e) => e.title == value);
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: appointmentController.emergencyController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Describe your emergency'.tr,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe your emergency'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    if (appointmentController.formKey.currentState?.validate() ?? false) {
                      if (selectedEmergency != null) {
                        appointmentController.sendUrgentAppointment(context, selectedEmergency!);
                      }
                    }
                  },
                  child:  Text(
                    'Get Urgent Appointment'.tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'We will contact you shortly to confirm your appointment.'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
List<EmergencyGuidance> emergencies = [
  EmergencyGuidance(
    title: "Toothache".tr,
    guidance: [
      "Rinse your mouth with warm water.".tr,
      "Use dental floss to remove any trapped food.".tr,
      "Apply a cold compress to your cheek if there is swelling.".tr,
      "Take over-the-counter pain relief medication if needed.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Knocked-Out Tooth".tr,
    guidance: [
      "Retrieve the tooth, holding it by the crown.".tr,
      "Rinse it with water but do not scrub.".tr,
      "If possible, reinsert it into the socket or place it in milk.".tr,
      "Get to your dentist as soon as possible.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Broken Tooth".tr,
    guidance: [
      "Rinse your mouth with warm water.".tr,
      "Save any pieces of the tooth.".tr,
      "Apply a cold compress to reduce swelling.".tr,
      "Avoid chewing on the affected side.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Severe Gum Pain".tr,
    guidance: [
      "Rinse your mouth with warm salt water.".tr,
      "Use a cold compress on your face to reduce pain and swelling.".tr,
      "Avoid very hot or cold foods and drinks.".tr,
      "See your dentist to identify and treat the underlying cause.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Chipped Tooth".tr,
    guidance: [
      "Rinse your mouth with warm water.".tr,
      "Save any broken pieces of the tooth.".tr,
      "Apply a cold compress to reduce swelling.".tr,
      "Visit your dentist as soon as possible for a proper repair.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Lost Filling or Crown".tr,
    guidance: [
      "Cover the exposed area with dental cement or sugar-free gum as a temporary measure.".tr,
      "Avoid chewing on that side of your mouth.".tr,
      "Contact your dentist to schedule an appointment for a replacement.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Bleeding Gums".tr,
    guidance: [
      "Rinse with warm salt water to reduce bleeding.".tr,
      "Apply gentle pressure with a clean gauze or cloth.".tr,
      "Avoid brushing or flossing the affected area until it stops bleeding.".tr,
      "If bleeding persists, consult your dentist.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Jaw Injury".tr,
    guidance: [
      "Apply ice to reduce swelling and pain.".tr,
      "Keep your jaw immobilized and avoid moving it.".tr,
      "If you experience severe pain or difficulty opening your mouth, seek immediate medical attention.".tr,
    ],
  ),
  EmergencyGuidance(
    title: "Abscessed Tooth".tr,
    guidance: [
      "Rinse your mouth with warm salt water to help relieve pain.".tr,
      "Apply a cold compress to reduce swelling.".tr,
      "Seek prompt dental care to address the infection and relieve pain.".tr,
    ],
  ),
];
