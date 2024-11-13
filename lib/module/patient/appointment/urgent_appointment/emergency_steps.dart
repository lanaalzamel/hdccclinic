import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/emergency_model.dart';

class EmergencyGuidanceScreen extends StatelessWidget {
  final EmergencyGuidance emergency;

  EmergencyGuidanceScreen({required this.emergency});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Guidance'.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed('/navigation');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              emergency.title,
              style: Theme.of(context).textTheme.headline4?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Text(
                'Helpful guidance for addressing dental emergencies:'.tr,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: emergency.guidance.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(Icons.info_outline,
                          color: Colors.redAccent, size: 30),
                      title: Text(emergency.guidance[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Action button to perform further actions
                _showMoreHelpDialog(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Need More Help'.tr,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreHelpDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('Need More Help?'.tr),
        content: Text(
            'You can contact us or visit our website for more assistance.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              // Example action: Open a contact page or website
              Get.back();
            },
            child: Text('Contact Us'.tr),
          ),
          TextButton(
            onPressed: () {
              // Example action: Open a help page or website
              Get.back();
            },
            child: Text('Visit Website'.tr),
          ),
        ],
      ),
    );
  }
}
