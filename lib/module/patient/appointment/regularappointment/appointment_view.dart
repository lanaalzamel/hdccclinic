import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:hdccapp/module/patient/appointment/regularappointment/regular_appointment_controller.dart';
import 'package:hdccapp/utlis/global_color.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../doctors/doctors_conroller.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final BookAppointmentController controller =
      Get.put(BookAppointmentController());
  final DoctorsController doctorsController = Get.put(DoctorsController());
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  bool _isPulsing = false;
  Timer? _pulseTimer;
  final DateFormat _timeFormat = DateFormat("HH:mm");

  @override
  void dispose() {
    _pulseTimer?.cancel();
    super.dispose();
  }

  void _startPulseEffect() {
    _pulseTimer = Timer.periodic(Duration(milliseconds: 800), (timer) {
      setState(() {
        _isPulsing = !_isPulsing;
      });
    });
  }

  void _stopPulseEffect() {
    _pulseTimer?.cancel();
    setState(() {
      _isPulsing = false;
    });
  }

  void _showDialog(String title, String message, bool success) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              success ? 'Awesome!'.tr : 'Oops!'.tr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                primary: success ? Colors.greenAccent : Colors.redAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Text('OK'.tr, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Book Appointment'.tr,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1?.color,
                fontSize: 25),
          ),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).textTheme.bodyText1?.color),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor Selection
                Text(
                  'Select your doctor'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                // Doctor list
                Container(
                  height: 150,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.6,
                    ),
                    itemCount: controller.doctors.length,
                    itemBuilder: (context, index) {
                      final doctor = controller.doctors[index];
                      final isSelected = doctor.id == controller.doctorId.value;
                      String photoUrl = doctor.photo != null
                          ? doctor.photo!.replaceFirst("127.0.0.1", "192.168.1.4")
                          : '';

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isSelected) {
                              controller.doctorId.value = doctor.id; // Update the selected doctor ID
                              controller.selectedTime.value = ''; // Clear the previously selected time
                              _selectedTime = null; // Clear selected time in UI
                              controller.fetchAvailableTimes(); // Fetch available times for the new doctor
                            }
                          });
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 8.0)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[400],
                                backgroundImage: (photoUrl.isNotEmpty)
                                    ? NetworkImage(photoUrl)
                                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                              ),

                              SizedBox(height: 8),
                              Text(
                                '${'doctor_title'.tr} ${doctor.firstName} ${doctor.lastName}'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                // Date Selection
                Text(
                  'Select Date'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.doctorId.value == 0) {
                        _startPulseEffect();
                        Get.snackbar(
                          "Doctor Not Selected".tr,
                          "Please select a doctor before choosing a date.".tr,
                          backgroundColor: Colors.redAccent.withOpacity(0.7),
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: controller.doctorId.value == 0,
                      child: TableCalendar(
                        calendarFormat: CalendarFormat.week,
                        calendarStyle: CalendarStyle(
                          selectedDecoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                        ),
                        firstDay: DateTime.now(),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: _selectedDay,
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (selectedDay.weekday != DateTime.friday) {
                            setState(() {
                              _selectedDay = selectedDay;
                              controller.date.value = selectedDay;
                              controller.fetchAvailableTimes();
                            });
                          } else {
                            _showDialog('Unavailable'.tr,
                                'Fridays are not selectable.'.tr, false);
                          }
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            if (day.weekday == DateTime.friday) {
                              return Center(
                                child: Text(
                                  day.day.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Appointment Time Selection
                Text(
                  'Select Appointment Time'.tr,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                if (controller.isLoadingTimes.value)
                  Center(child: CircularProgressIndicator())
                else if (controller.availableTimes.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No available times for the selected date.'.tr),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.availableTimes.map((time) {
                        final formattedTime = _timeFormat.format(time);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTime = formattedTime;
                              controller.selectedTime.value =
                                  formattedTime; // Update this line
                              print(
                                  "Selected Time: ${controller.selectedTime.value}");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            // Adjust padding for better appearance
                            decoration: BoxDecoration(
                              color: _selectedTime == formattedTime
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                              // Set the background color based on selection
                              borderRadius: BorderRadius.circular(
                                  20), // Optional rounded corners
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedTime == formattedTime) {
                                    // If the same time slot is selected, deselect it
                                    _selectedTime = null;
                                    controller.selectedTime.value = '';
                                  } else {
                                    // Select the time slot
                                    _selectedTime = formattedTime;
                                    controller.selectedTime.value =
                                        formattedTime;
                                  }
                                });
                              },
                              child: Text(
                                formattedTime,
                                style: TextStyle(
                                  color: _selectedTime == formattedTime
                                      ? Colors.white
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.color,
                                  // Adjust text color based on selection
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Spacer(),
                // Book Button

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controller.doctorId.value != 0 &&
                            _selectedTime != null) {
                          controller.bookAppointment().then((success) {
                            if (success) {
                              HapticFeedback.mediumImpact();
                              _showDialog(
                                "Success".tr,
                                "Appointment booked successfully!".tr,
                                true,
                              );
                            } else {
                              // Display the first error message from the list if available
                              String errorMessage = controller
                                      .errorMessages.isNotEmpty
                                  ? controller.errorMessages.first.replaceAll(
                                      RegExp(r'^Failed to book appointment: '.tr),
                                      '')
                                  : "Failed to book appointment".tr;
                              _showDialog(
                                "Error",
                                errorMessage,
                                false,
                              );
                            }
                          });
                        } else {
                          _showDialog(
                            "Error".tr,
                            "Please select a doctor and time".tr,
                            false,
                          );
                        }
                      },
                      child: Text('Book Appointment'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.mainColor,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
