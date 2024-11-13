// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:io';
// import 'package:hdccapp/module/patient/patient_profile/patient_profile_service.dart';
// import 'package:hdccapp/module/patient/patient_profile/patient_profilr_controller.dart';
// import 'package:hdccapp/utlis/global_color.dart';
// import '../../../models/patient.dart';
// import '../../../native_service/secure_storage.dart';
// import '../../../config/server_config.dart';
// import '../cancel_appointment/cancel_appointment_controller.dart';
//
// class PatientProfile extends StatefulWidget {
//   PatientProfile({Key? key}) : super(key: key);
//
//   @override
//   State<PatientProfile> createState() => _PatientProfileState();
// }
//
// class _PatientProfileState extends State<PatientProfile> {
//   final Securestorage secureStorage = Securestorage();
//   CancelAppointmentController cancelAppointmentController =
//       Get.put(CancelAppointmentController());
//   final FilterController filterController = Get.put(FilterController(
//     appointmentService:
//         AppointmentService(baseUrl: ServerConfig.domainNameServer),
//   ));
//
//   Future<Patient?> _getPatientInfo() async {
//     return await secureStorage.getPatient();
//   }
//
//   String getAvatarUrl(String url) {
//     if (Platform.isAndroid) {
//       return url.replaceFirst('127.0.0.1', '10.0.2.2');
//     }
//     return url;
//   }
//
//   late Future<Patient?> patientInfo;
//
//   Widget _buildAvatar(String? avatarUrl) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         // Replace with GlobalColors.backgroundColor if defined
//         shape: BoxShape.circle,
//       ),
//       child: ClipOval(
//         child: SizedBox.fromSize(
//           size: const Size.fromRadius(70),
//           child: avatarUrl != null && avatarUrl.isNotEmpty
//               ? Image.network(
//                   getAvatarUrl(avatarUrl),
//                   fit: BoxFit.cover,
//                   errorBuilder: (BuildContext context, Object exception,
//                       StackTrace? stackTrace) {
//                     return Image.asset(
//                       'assets/images/profile.jpg',
//                       fit: BoxFit.cover,
//                     );
//                   },
//                 )
//               : Image.asset(
//                   'assets/images/profile.jpg',
//                   fit: BoxFit.cover,
//                 ),
//         ),
//       ),
//     );
//   }
//
//   final List<Tab> _tabs = [
//     const Tab(text: 'Appointments'),
//     const Tab(
//       text: 'Treatment Plan',
//     ),
//     const Tab(text: 'Medical record'),
//   ];
//
//   final double coverHeight = 150;
//
//   final double profileHeight = 144;
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'upcoming':
//         return Colors.green;
//       case 'completed':
//         return Colors.blue;
//       case 'canceled':
//         return Colors.red;
//       default:
//         return Colors.black;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Define custom text styles for tabs
//     final TextStyle selectedTabStyle = TextStyle(
//       fontFamily: 'Poppins',
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       color: Theme.of(context).primaryColor,
//     );
//
//     final TextStyle unselectedTabStyle = TextStyle(
//       fontFamily: 'Poppins',
//       fontSize: 14,
//       color: Colors.black54,
//     );
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DefaultTabController(
//         length: _tabs.length,
//         child: SafeArea(
//           child: Scaffold(
//             backgroundColor:
//                 Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
//             appBar: AppBar(
//               backgroundColor: Theme.of(context).primaryColor,
//               leading: InkWell(
//                 onTap: () {
//                   Navigator.pop(context); // Use pop to navigate back
//                 },
//                 child: const Icon(Icons.arrow_back),
//               ),
//             ),
//             body: FutureBuilder<Patient?>(
//               future: _getPatientInfo(),
//               builder:
//                   (BuildContext context, AsyncSnapshot<Patient?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error fetching patient data'.tr));
//                 } else if (!snapshot.hasData || snapshot.data == null) {
//                   return Center(child: Text('No patient data available'.tr));
//                 } else {
//                   final Patient patient = snapshot.data!;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       Stack(
//                         clipBehavior: Clip.none,
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             height: coverHeight,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).primaryColor,
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(40),
//                                 bottomRight: Radius.circular(40),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: coverHeight - profileHeight / 2,
//                             child: _buildAvatar(patient.avatar),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: profileHeight / 2 + 10),
//                       Center(
//                         child: Text(
//                           '${patient.firstName ?? ''} ${patient.lastName ?? ''}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontFamily: "Poppins",
//                             fontSize: 20,
//                             color: Theme.of(context).textTheme.bodyText1?.color,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       TabBar(
//                         tabs: _tabs,
//                         labelStyle: selectedTabStyle,
//                         unselectedLabelStyle: unselectedTabStyle,
//                         indicator: UnderlineTabIndicator(
//                           borderSide: BorderSide(
//                             width: 3.0,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                           insets: const EdgeInsets.symmetric(horizontal: 16.0),
//                         ),
//                         labelColor: Theme.of(context).primaryColor,
//                         unselectedLabelColor:
//                             Theme.of(context).textTheme.bodyText1?.color,
//                       ),
//                       Expanded(
//                         child: TabBarView(
//                           children: [
//                             // Appointments Screen Content
//                             Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       IconButton(
//                                         icon: const Icon(Icons.search),
//                                         onPressed: () {
//                                           // Add your onPressed logic here
//                                         },
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(
//                                             Icons.filter_alt_rounded),
//                                         onPressed: () {
//                                           showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title:
//                                                     Text('Popup Container'.tr),
//                                                 content: Column(
//                                                   mainAxisSize:
//                                                       MainAxisSize.min,
//                                                   children: [
//                                                     Obx(
//                                                       () => RadioListTile(
//                                                         title: Text('All'.tr),
//                                                         value: 'All',
//                                                         groupValue:
//                                                             filterController
//                                                                 .selectedOption
//                                                                 .value,
//                                                         onChanged: (value) {
//                                                           filterController
//                                                                   .selectedOption
//                                                                   .value =
//                                                               value as String;
//                                                           filterController
//                                                               .fetchAppointments(
//                                                                   value,
//                                                                   patient.id);
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                     Obx(
//                                                       () => RadioListTile(
//                                                         title:
//                                                             Text('Upcoming'.tr),
//                                                         value: 'Upcoming',
//                                                         groupValue:
//                                                             filterController
//                                                                 .selectedOption
//                                                                 .value,
//                                                         onChanged: (value) {
//                                                           filterController
//                                                                   .selectedOption
//                                                                   .value =
//                                                               value as String;
//                                                           filterController
//                                                               .fetchAppointments(
//                                                                   value,
//                                                                   patient.id);
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                     Obx(
//                                                       () => RadioListTile(
//                                                         title: Text(
//                                                             'Completed'.tr),
//                                                         value: 'Completed',
//                                                         groupValue:
//                                                             filterController
//                                                                 .selectedOption
//                                                                 .value,
//                                                         onChanged: (value) {
//                                                           filterController
//                                                                   .selectedOption
//                                                                   .value =
//                                                               value as String;
//                                                           filterController
//                                                               .fetchAppointments(
//                                                                   value,
//                                                                   patient.id);
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                     Obx(
//                                                       () => RadioListTile(
//                                                         title:
//                                                             Text('Canceled'.tr),
//                                                         value: 'Canceled',
//                                                         groupValue:
//                                                             filterController
//                                                                 .selectedOption
//                                                                 .value,
//                                                         onChanged: (value) {
//                                                           filterController
//                                                                   .selectedOption
//                                                                   .value =
//                                                               value as String;
//                                                           filterController
//                                                               .fetchAppointments(
//                                                                   value,
//                                                                   patient.id);
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Obx(
//                                   () {
//                                     if (filterController.appointments.isEmpty) {
//                                       return Center(
//                                           child: Text(
//                                               'No appointments available'.tr));
//                                     } else {
//                                       return Expanded(
//                                         child: RefreshIndicator(
//                                           onRefresh: () async {
//                                             setState(() {
//                                               patientInfo = _getPatientInfo();
//                                               patientInfo.then((patient) {
//                                                 if (patient != null) {
//                                                   filterController
//                                                       .fetchAppointments(
//                                                           'All', patient.id);
//                                                 }
//                                               });
//                                             });
//                                           },
//                                           child: ListView.builder(
//                                             itemCount: filterController
//                                                 .appointments.length,
//                                             itemBuilder: (context, index) {
//                                               final appointment =
//                                                   filterController
//                                                       .appointments[index];
//
//                                               return Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(12.0),
//                                                 child: Card(
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               'Date :'.tr,
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               appointment.date ==
//                                                                       'urgent'
//                                                                           .tr
//                                                                   ? appointment
//                                                                       .date
//                                                                   : appointment
//                                                                       .date,
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: appointment
//                                                                             .date ==
//                                                                         'urgent'
//                                                                     ? Colors.red
//                                                                     : Theme.of(
//                                                                             context)
//                                                                         .textTheme
//                                                                         .bodyText1
//                                                                         ?.color,
//                                                                 fontWeight: appointment
//                                                                             .date ==
//                                                                         'urgent'
//                                                                     ? FontWeight
//                                                                         .bold
//                                                                     : FontWeight
//                                                                         .normal,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Align(
//                                                           alignment: Alignment
//                                                               .centerRight,
//                                                           child: Text(
//                                                             appointment.time,
//                                                             style: TextStyle(
//                                                               fontFamily:
//                                                                   "Poppins",
//                                                               color: Theme.of(
//                                                                       context)
//                                                                   .textTheme
//                                                                   .bodyText1
//                                                                   ?.color,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               'Doctor :'.tr,
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               '${appointment.doctor.firstName} ${appointment.doctor.lastName}',
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             Text(
//                                                               'Appointment reason :'
//                                                                   .tr,
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                               ),
//                                                             ),
//                                                             Text(
//                                                               appointment
//                                                                       .reason ??
//                                                                   'No reason provided'
//                                                                       .tr,
//                                                               style: TextStyle(
//                                                                 fontFamily:
//                                                                     "Poppins",
//                                                                 color: Theme.of(
//                                                                         context)
//                                                                     .textTheme
//                                                                     .bodyText1
//                                                                     ?.color,
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Align(
//                                                               alignment: Alignment
//                                                                   .centerRight,
//                                                               child: Container(
//                                                                 padding: EdgeInsets
//                                                                     .symmetric(
//                                                                         horizontal:
//                                                                             8,
//                                                                         vertical:
//                                                                             4),
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: _getStatusColor(
//                                                                           appointment
//                                                                               .status)
//                                                                       .withOpacity(
//                                                                           0.2),
//                                                                   // Lighter background color
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               4),
//                                                                 ),
//                                                                 child: Text(
//                                                                   appointment
//                                                                       .status,
//                                                                   style:
//                                                                       TextStyle(
//                                                                     color: _getStatusColor(
//                                                                         appointment
//                                                                             .status),
//                                                                     fontFamily:
//                                                                         "Poppins",
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             if (appointment
//                                                                     .status
//                                                                     .toLowerCase() ==
//                                                                 'upcoming') ...[
//                                                               SizedBox(
//                                                                   width: 10),
//                                                               ElevatedButton(
//                                                                 onPressed: () {
//                                                                   _showCancelConfirmationDialog(
//                                                                       appointment
//                                                                           .id);
//                                                                 },
//                                                                 child: Text(
//                                                                     'Cancel'
//                                                                         .tr),
//                                                               ),
//                                                             ],
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               ],
//                             ),
//                             // Treatment Plan Screen Content
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: SingleChildScrollView(
//                                 child: Card(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(5.0),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Your teatment plan:'.tr),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                         Text(
//                                           patient.treatmentPlan ??
//                                               'No treatment plan available',
//                                           style: const TextStyle(
//                                             fontFamily: "Poppins",
//                                             fontSize: 16,
//                                           ),
//                                           //  textAlign: TextAlign.center, // Adjust alignment as per your requirement
//                                           maxLines: 2, // Limit to 2 lines
//                                           // overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Medical Record Screen Content
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: SingleChildScrollView(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Card(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'The medical record:'.tr,
//                                             style: const TextStyle(
//                                               fontFamily: "Poppins",
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             patient.medicalRecord?.diagnosis ??
//                                                 'No medical record available',
//                                             style: const TextStyle(
//                                               fontFamily: "Poppins",
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           if (patient.medicalRecord?.photos !=
//                                               null) // Check if photos are available
//                                             Image.network(
//                                               patient.medicalRecord!.photos!,
//                                               width: 200,
//                                               // Adjust width as per your requirement
//                                               height: 200,
//                                               // Adjust height as per your requirement
//                                               fit: BoxFit
//                                                   .cover, // Adjust fit property as per your image aspect ratio
//                                             ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTop(String? avatarUrl) {
//     final top = coverHeight - profileHeight / 2;
//     final bottom = profileHeight / 2;
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: Alignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.only(bottom: bottom),
//           child: buildCoverImage(),
//         ),
//         Positioned(top: top, child: _buildAvatar(avatarUrl)),
//       ],
//     );
//   }
//
//   Widget buildCoverImage() => Container(
//         color: Theme.of(context).primaryColor,
//         height: coverHeight,
//         width: double.infinity,
//       );
//
//   void _showCancelConfirmationDialog(int appointmentId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Cancel Appointment'.tr),
//           content: Text('Are you sure you want to cancel this appointment?'.tr),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('No'.tr),
//             ),
//             TextButton(
//               onPressed: () {
//                 cancelAppointmentController.cancelAppointment(appointmentId);
//                 Navigator.pop(context);
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
