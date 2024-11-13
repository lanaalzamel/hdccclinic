import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utlis/global_color.dart';
import '../../../config/user_info.dart';
import '../doctor_request_details/request_record_details.dart';
import 'complete_list_details.dart';
import 'completed_list_controller.dart';

class CompletedList extends StatelessWidget {
  final UpdatedRequestController controller = Get.put(UpdatedRequestController());

  Future<void> _refreshLabRequests() async {
    print('Refreshing lab requests...');

    await controller.fetchUpdateRequests(Userinformation.id);
  }

  CompletedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Completed & Updated Requests'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    height: 600,
                    width: 332,
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (controller.updateRequests.isNotEmpty) {
                        var reversedRequests = List.from(controller.updateRequests.reversed);
                        return RefreshIndicator(
                          onRefresh: _refreshLabRequests,
                          child: ListView.separated(
                            itemCount: reversedRequests.length,
                            separatorBuilder: (context, index) => Divider(
                              color: GlobalColors.mainColor.withOpacity(0.2),
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              var updateRequest = reversedRequests[index];
                              return ListTile(
                                onTap: () {
                                  Get.to(() => CompleteListDetailsPage(request: updateRequest));
                                },
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor: GlobalColors.mainColor.withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: GlobalColors.mainColor,
                                  ),
                                  radius: 25,
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      '${'doctor_title'.tr} ${updateRequest.doctorName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.bodyText1?.color,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Status Badge for "Completed"
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Completed'.tr,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  updateRequest.patientName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).textTheme.bodyText1?.color,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.inbox,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No update requests found.'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontFamily: "Poppins",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Please check back later.'.tr,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                    fontFamily: "Poppins",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
