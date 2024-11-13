import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/Widgets/button.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import '../../../models/medical_histort_model.dart';
import 'medical_history_controller.dart';

class MedicalHistoryView extends StatelessWidget {
  final MedicalHistoryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
      appBar: AppBar(
        title: Text('Medical History'.tr),
        backgroundColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 16),

            // Filter Dropdown for Date Range
            _buildDateRangeDropdown(),

            SizedBox(height: 16),

            // Medical History List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (controller.filteredMedicalHistoryList.isEmpty) {
                  return Center(child: Text('No medical history found.'.tr));
                } else {
                  return ListView.builder(
                    itemCount: controller.filteredMedicalHistoryList.length,
                    itemBuilder: (context, index) {
                      return _buildTimelineTile(
                        context,
                        controller.filteredMedicalHistoryList[index],
                        index,
                        controller.filteredMedicalHistoryList.length,
                      );
                    },
                  );
                }
              }),
            ),
            // Center(
            //     child: MyButton(
            //         titleColor: Colors.white,
            //         color: Theme.of(Get.context!).primaryColor,
            //         title: "download".tr,
            //         onTap: () {
            //           controller.downloadMedicalHistory();
            //         },
            //         height: 50,
            //         width: 150))
          ],
        ),
      ),
    );
  }

  // Build Date Range Dropdown
  Widget _buildDateRangeDropdown() {
    return Obx(() => DropdownButton<String>(
      value: controller.selectedDateRange.value,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Theme.of(Get.context!).primaryColor,
      ),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.setSelectedDateRange(newValue);
          controller.filterByPredefinedDateRange(newValue);
        }
      },
      items: <String>[
        'Last 7 days',
        'Last 2 months',
        'Last year',
        'all',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
    ));
  }

  Widget _buildTimelineTile(
      BuildContext context, MedicalHistory history, int index, int length) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: index == 0,
      isLast: index == length - 1,
      indicatorStyle: IndicatorStyle(
        width: 20,
        color: Theme.of(context).primaryColor,
        iconStyle: IconStyle(
          iconData: Icons.check,
          color: Colors.white,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: Theme.of(context).primaryColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        color: Theme.of(context).primaryColor,
        thickness: 2,
      ),
      endChild: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: _buildMedicalHistoryCard(context, history),
      ),
    );
  }

  Widget _buildMedicalHistoryCard(
      BuildContext context, MedicalHistory history) {
    final photoUrl = history.photos?.replaceAll("127.0.0.1", "192.168.1.4") ?? '';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      _getMonthFromDate(history.date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getDayFromDate(history.date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [
                          _buildDetailItem("Condition".tr, history.diagnosis),
                          _buildDetailItem("Treatment".tr, history.treatment),
                          _buildDetailItem("Dentist".tr,
                              '${'doctor_title'.tr} ${history.doctorName}'),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (history.notes.isNotEmpty)
                        _buildNotesSection(history.notes),
                      // Add Image Icon here
                      SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.image,color: Theme.of(Get.context!).primaryColor,),
                            onPressed: () {
                              _showImageDialog(context, photoUrl);
                            },
                          ),
                          Text('Tap here to view the image'.tr),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Method to show image pop-up dialog
  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Close".tr),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(String notes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Notes:".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(8.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: Text(
            notes,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthFromDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat.MMM().format(parsedDate);
  }

  String _getDayFromDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return "${parsedDate.day}";
  }
}
