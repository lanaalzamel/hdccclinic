import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hdccapp/module/patient/chat/chat_controller.dart';
import 'package:hive/hive.dart';
import '../../../doctors/doctors_service.dart';
import '../../../models/chat_model.dart';
import '../../../models/show_doctors.dart';
import 'home_chat.dart'; // Ensure the path matches your structure

class PatientChatListScreen extends StatefulWidget {
  final int patientId;

  PatientChatListScreen({Key? key, required this.patientId}) : super(key: key);

  @override
  _PatientChatListScreenState createState() => _PatientChatListScreenState();
}

Future<void> cachePatientChats(List<Chat> chats) async {
  final box = await Hive.openBox<Chat>('patientChats');
  await box.clear(); // Clear old cache
  await box.addAll(chats); // Store new chats
}

Future<void> cacheDoctors(List<Doctors> doctors) async {
  final box = await Hive.openBox<Doctors>('doctors');
  await box.clear();
  await box.addAll(doctors);
}

Future<List<Chat>> getCachedPatientChats() async {
  final box = await Hive.openBox<Chat>('patientChats');
  return box.values.toList();
}

Future<List<Doctors>> getCachedDoctors() async {
  final box = await Hive.openBox<Doctors>('doctors');
  return box.values.toList();
}

class _PatientChatListScreenState extends State<PatientChatListScreen> {
  final ChatController chatController = Get.put(ChatController());
  final doctorsService = doctorsSrevecie();
  List<Doctors> doctorsList = [];
  List<Doctors> filteredDoctorsList = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCachedData();
    fetchData(); // Load fresh data from the server
    searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    searchController
        .dispose(); // Dispose the controller when the screen is closed
    super.dispose();
  }

  Future<void> loadCachedData() async {
    // Load cached chats
    chatController.patientChats.value = await getCachedPatientChats();
    // Load cached doctors
    doctorsList = await getCachedDoctors();
  }

  // Fetch patient chats and doctors data
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    await chatController.fetchPatientChats(widget.patientId);
    await fetchDoctors();
    await cachePatientChats(chatController.patientChats);
    await cacheDoctors(doctorsList);
    setState(() {
      isLoading = false;
      filteredDoctorsList = doctorsList; // Reset filter after fetching data
    });
  }

  // Fetch doctors data from the service
  Future<void> fetchDoctors() async {
    try {
      doctorsList = await doctorsService.getDoctors();
      setState(() {
        filteredDoctorsList = doctorsList; // Update filtered list after fetch
      });
    } catch (e) {
      print('Failed to fetch doctors: $e');
    }
  }

  // Filter doctors based on search query
  void _filterDoctors() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctorsList = doctorsList.where((doctor) {
        final fullName = '${doctor.firstName} ${doctor.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  // Find doctor details by ID
  Doctors? findDoctorById(int doctorId) {
    return doctorsList.firstWhereOrNull((doctor) => doctor.id == doctorId);
  }

  List<Doctors> getAvailableDoctors() {
    final chatDoctorIds =
        chatController.patientChats.map((chat) => chat.doctorId).toSet();
    return filteredDoctorsList
        .where((doctor) => !chatDoctorIds.contains(doctor.id))
        .toList();
  }

  void showAvailableDoctors() {
    final availableDoctors = getAvailableDoctors();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return availableDoctors.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "No available doctors to start a chat with at the moment.".tr,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: availableDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = availableDoctors[index];
                  final photoUrl = doctor.photo
                      ?.replaceAll("127.0.0.1", "192.168.1.4") ??
                      '';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: doctor.photo != null
                          ? NetworkImage(photoUrl)
                          : AssetImage('assets/images/profile1.jpg')
                              as ImageProvider,
                    ),
                    title: Text(
                      '${doctor.firstName} ${doctor.lastName}',
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    subtitle: Text(
                      doctor.specialization ?? 'Specialization not available'.tr,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      startChatWithDoctor(doctor);
                    },
                  );
                },
              );
      },
    );
  }

  Future<void> startChatWithDoctor(Doctors doctor) async {
    try {
      // Clear previous chat data before starting a new chat
      chatController.clearChatData(); // Clear messages and reset chatId

      // Navigate to the chat screen without preloading any messages
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            patientId: widget.patientId.toString(),
            doctorId: doctor.id.toString(),
            chatId: '',
            // Pass an empty chatId to start fresh
            doctorName: '${'doctor_title'.tr}${doctor?.firstName} ${doctor?.lastName}',
            doctorPhoto: doctor.photo ?? '',
          ),
        ),
      );
    } catch (e) {
      print('Failed to start chat with doctor: $e');
    }
  }
  Widget buildChatTile(Chat chat, Doctors? doctor) {
    final photoUrl = doctor?.photo != null
        ? doctor!.photo!.replaceAll("127.0.0.1", "192.168.1.4")
        : ''; // Safely handle null values for photo

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipOval(
        child: Container(
          width: 60, // Adjust the size as needed
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: (doctor?.photo != null && photoUrl.isNotEmpty)
                  ? NetworkImage(photoUrl)
                  : AssetImage('assets/images/profile1.jpg') as ImageProvider,
              fit: BoxFit.cover, // Ensures the image fits properly inside the circle
            ),
          ),
        ),
      ),
      title: Text(
        doctor != null
            ? '${'doctor_title'.tr} ${doctor.firstName} ${doctor.lastName}'
            : 'Doctor ID: ${chat.doctorId}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Poppins",
          color: Theme.of(context).textTheme.bodyText1?.color,
        ),
      ),
      subtitle: Text(
        "how are you today!".tr ?? 'No messages yet',
        style: TextStyle(color: Colors.grey[600]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chat.updatedAt != null ? chat.updatedAt!.substring(0, 10) : '',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 4),
        ],
      ),
      onTap: () {
        print('patientId:${chat.patientId.toString()}');
        print('doctorId:${chat.doctorId.toString()}');
        print('chatId:${chat.id.toString()}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              patientId: chat.patientId.toString(),
              doctorId: chat.doctorId.toString(),
              chatId: chat.id.toString(),
              doctorName: doctor != null
                  ? '${'doctor_title'.tr} ${doctor.firstName} ${doctor.lastName}'
                  : 'Doctor ID: ${chat.doctorId}',
              doctorPhoto: doctor?.photo ?? '',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search doctors...'.tr,
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
          onChanged: (value) {
            // Call the search function whenever the user types something
            _filterDoctors(); // Update the filtered chats
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: Obx(() {
                final filteredChats = chatController.patientChats.where((chat) {
                  final doctor = findDoctorById(chat.doctorId);
                  final doctorName = doctor != null
                      ? '${doctor.firstName} ${doctor.lastName}'.toLowerCase()
                      : '';
                  final query = searchController.text.toLowerCase();
                  return doctorName.contains(query);
                }).toList();
                // Check if there are no chats
                if (filteredChats.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "You have no chats yet. Start a conversation by selecting a doctor.".tr,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    final doctor = findDoctorById(chat.doctorId);

                    return Column(
                      children: [
                        buildChatTile(chat, doctor),
                        if (index < filteredChats.length - 1)
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                            indent: 16,
                            endIndent: 20,
                          ),
                      ],
                    );
                  },
                );
              }),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: FloatingActionButton(
          onPressed: showAvailableDoctors,
          child: Icon(Icons.message, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 4,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
