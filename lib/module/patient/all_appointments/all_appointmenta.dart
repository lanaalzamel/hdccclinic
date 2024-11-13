import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/server_config.dart';
import '../../../models/appointment_by_status_model.dart';
import '../../../models/patient.dart';
import '../../../native_service/secure_storage.dart';
import '../cancel_appointment/cancel_appointment_controller.dart';
import '../patient_profile/patient_profile_service.dart';
import '../patient_profile/patient_profilr_controller.dart';

class AllAppointment extends StatefulWidget {
  const AllAppointment({Key? key}) : super(key: key);

  @override
  State<AllAppointment> createState() => _AllAppointmentState();
}

class _AllAppointmentState extends State<AllAppointment> {
  late List<AppointmentByStatus> appointments;

  @override
  void initState() {
    super.initState();
    appointments = Get.arguments ?? []; // Get the appointments from arguments
  }

  final FilterController filterController = Get.put(FilterController(
    appointmentService:
    AppointmentService(baseUrl: ServerConfig.domainNameServer),
  ));
  final Securestorage secureStorage = Securestorage();
  CancelAppointmentController cancelAppointmentController =
  Get.put(CancelAppointmentController());

  Future<Patient?> _getPatientInfo() async {
    return await secureStorage.getPatient();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Patient?>(
        future: _getPatientInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No patient information found'));
          }
          final Patient patient = snapshot.data!;

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('All Appointments'.tr), // Change the title as needed
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back(); // Navigate back to the previous screen
                  },
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Add your onPressed logic here
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_alt_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Popup Container'.tr),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Obx(
                                            () => RadioListTile(
                                          title: Text('All'.tr),
                                          value: 'All',
                                          groupValue: filterController.selectedOption.value,
                                          onChanged: (value) {
                                            filterController.selectedOption.value = value as String;
                                            filterController.fetchAppointments(value, patient.id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Obx(
                                            () => RadioListTile(
                                          title: Text('Upcoming'.tr),
                                          value: 'Upcoming',
                                          groupValue: filterController.selectedOption.value,
                                          onChanged: (value) {
                                            filterController.selectedOption.value = value as String;
                                            filterController.fetchAppointments(value, patient.id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Obx(
                                            () => RadioListTile(
                                          title: Text('Completed'.tr),
                                          value: 'Completed',
                                          groupValue: filterController.selectedOption.value,
                                          onChanged: (value) {
                                            filterController.selectedOption.value = value as String;
                                            filterController.fetchAppointments(value, patient.id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                      Obx(
                                            () => RadioListTile(
                                          title: Text('Canceled'.tr),
                                          value: 'Canceled',
                                          groupValue: filterController.selectedOption.value,
                                          onChanged: (value) {
                                            filterController.selectedOption.value = value as String;
                                            filterController.fetchAppointments(value, patient.id);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Obx(
                        () {
                      if (filterController.appointments.isEmpty) {
                        return Center(child: Text('No appointments available'.tr));
                      } else {
                        return Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              setState(() {
                                _getPatientInfo().then((patient) {
                                  if (patient != null) {
                                    filterController.fetchAppointments('All', patient.id);
                                  }
                                });
                              });
                            },
                            child: ListView.builder(
                              itemCount: filterController.appointments.length,
                              itemBuilder: (context, index) {
                                final appointment = filterController.appointments[index];

                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Date:'.tr,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                              ),
                                              Text(
                                                appointment.date == 'urgent'.tr
                                                    ? appointment.date
                                                    : appointment.date,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: appointment.date == 'urgent'
                                                      ? Colors.red
                                                      : Theme.of(context).textTheme.bodyText1?.color,
                                                  fontWeight: appointment.date == 'urgent'
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              appointment.time,
                                              style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Theme.of(context).textTheme.bodyText1?.color,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Doctor:'.tr,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                              ),
                                              Text(
                                                '${appointment.doctor.firstName} ${appointment.doctor.lastName}',
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Appointment reason :'.tr,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                              ),
                                              Text(
                                                appointment.reason ?? 'No reason provided'.tr,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Theme.of(context).textTheme.bodyText1?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: _getStatusColor(appointment.status).withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    appointment.status,
                                                    style: TextStyle(
                                                      color: _getStatusColor(appointment.status),
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (appointment.status.toLowerCase() == 'upcoming'.tr) ...[
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _showCancelConfirmationDialog(appointment.id);
                                                  },
                                                  child: Text('Cancel'.tr),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showCancelConfirmationDialog(int appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'.tr),
          content: Text('Are you sure you want to cancel this appointment?'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'.tr),
            ),
            TextButton(
              onPressed: () {
                cancelAppointmentController.cancelAppointment(appointmentId);
                Navigator.pop(context);
              },
              child: Text('Yes'.tr),
            ),
          ],
        );
      },
    );
  }
}
