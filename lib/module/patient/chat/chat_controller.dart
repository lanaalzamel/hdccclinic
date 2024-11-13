import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../config/server_config.dart';
import '../../../models/chat_model.dart';
import '../../../models/message_model.dart';
import '../../../models/show_doctors.dart'; // Ensure the path matches your structure

class ChatController extends GetxController {
  var chatId =
      ''.obs; // Chat ID will be initialized only after a new chat starts
  RxList<Message> messages = <Message>[].obs;
  RxList<Chat> patientChats = <Chat>[].obs; // List to hold patient chats
  late PusherChannelsFlutter pusher;

  final String apiKey =
      '94d2398297812341c099'; // Replace with your Pusher API key
  final String cluster = 'ap2'; // Replace with your Pusher cluster
  final String channelName = 'chat'; // Replace with your channel name

  bool pusherEventSubscribed = false; // Flag to avoid multiple subscriptions

  @override
  void onInit() {
    super.onInit();
    _initPusher();
    if (chatId.value.isNotEmpty) {
      getMessages();
    }
  }

  // Clear chat data
  void clearChatData() {
    chatId.value = '';
    messages.clear();
  }

  // Set chat ID and fetch messages
  void setChatId(String id) {
    if (chatId.value != id) {
      chatId.value = id;
      messages.clear();
      getMessages();
    }
  }

  // Add a message to the UI
  void addMessage(Message message) {
    // Check for duplicates based on timestamp, content, and sender
    bool messageExists = messages.any((msg) =>
        msg.timestamp.isAtSameMomentAs(message.timestamp) &&
        msg.content == message.content &&
        msg.sender == message.sender);

    if (!messageExists) {
      messages.add(message);
      messages.refresh();
    } else {
      print('Duplicate message detected, not adding: ${message.content}');
    }
  }

  // Update the message status
  void updateMessageStatus(Message message, MessageStatus newStatus) {
    final index = messages.indexWhere((msg) =>
        msg.timestamp.isAtSameMomentAs(message.timestamp) &&
        msg.content == message.content);

    if (index != -1) {
      final updatedMessage = messages[index].copyWith(status: newStatus);
      messages[index] = updatedMessage;
      messages.refresh();
    } else {
      print('Message not found in list for status update: ${message.content}');
    }
  }

  // Fetch all chats associated with a specific patient
  Future<void> fetchPatientChats(int patientId) async {
    var url =
    Uri.parse(ServerConfig.domainNameServer + ServerConfig.fetchPatientChats(patientId));
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> chatsData = data['chats'];

        patientChats.value =
            chatsData.map<Chat>((chat) => Chat.fromJson(chat)).toList();
        print('Chats retrieved successfully for patientId: $patientId');
      } else {
        print('Failed to retrieve chats: ${response.body}');
      }
    } catch (e) {
      print('Error fetching patient chats: $e');
    }
  }

  // Fetch messages for the current chat ID
  Future<void> getMessages() async {
    if (chatId.value.isEmpty) {
      print('No chatId found, skipping message fetch');
      return;
    }
    var url =
    Uri.parse(ServerConfig.domainNameServer + ServerConfig.getMessages);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'chat_id': chatId.value}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> messagesData = data['messages'];

      for (var msgData in messagesData) {
        final message = Message.fromJson(msgData);
        addMessage(message);
      }

      print('Messages retrieved successfully for chatId: ${chatId.value}');
    } else {
      print('Failed to retrieve messages: ${response.body}');
    }
  }

  // Initialize Pusher and subscribe to events
  Future<void> _initPusher() async {
    try {
      pusher = PusherChannelsFlutter.getInstance();
      print("Pusher instance created");

      // Initialize Pusher
      await pusher.init(
        apiKey: apiKey,
        cluster: cluster,
        onConnectionStateChange: (currentState, previousState) {
          print("Pusher connection state changed: $currentState");
        },
        onError: (message, code, exception) {
          print("Pusher error: $message, Code: $code, Exception: $exception");
        },
      );
      print("Pusher initialized");

      // Avoid multiple subscriptions to Pusher events
      if (!pusherEventSubscribed) {
        pusher.subscribe(
          channelName: channelName,
          onEvent: (event) {
            print(
                'Received Pusher event: ${event.eventName}, data: ${event.data}');

            try {
              final messageData = jsonDecode(event.data)['message'];
              final receivedMessage = Message.fromJson(messageData);

              // Check for duplicates before adding
              bool messageExists = messages.any((msg) =>
                  msg.timestamp.isAtSameMomentAs(receivedMessage.timestamp) &&
                  msg.sender == receivedMessage.sender &&
                  msg.content == receivedMessage.content);

              if (!messageExists) {
                addMessage(receivedMessage);
              } else {
                print(
                    'Duplicate message detected from Pusher, not adding: ${receivedMessage.content}');
              }
            } catch (e) {
              print("Error decoding event data: $e");
            }
          },
        );
        pusherEventSubscribed =
            true; // Ensure this flag is set to avoid multiple subscriptions
      }

      print("Subscribed to channel: $channelName");
      await pusher.connect();
      print("Pusher connected");
    } catch (e) {
      print("Error initializing Pusher: $e");
    }
  }

  @override
  void onClose() {
    if (pusher != null) {
      pusher.disconnect();
      print("Pusher disconnected");
    }
    super.onClose();
  }

  // Send a message and update its status
  Future<void> sendMessage({
    required String patientId,
    required String doctorId,
    required String content,
  }) async {
    Message newMessage = Message(
      content: content,
      sender: 'patient',
      timestamp: DateTime.now(),
      isSeen: false,
      status: MessageStatus.sending,
    );
    var url =
    Uri.parse(ServerConfig.domainNameServer + ServerConfig.patient_send_message);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'patient_id': patientId,
          'doctor_id': doctorId,
          'content': content,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (chatId.value.isEmpty) {
          chatId.value = data['chat_id'].toString();
        }

        newMessage.status = MessageStatus.sent;
        updateMessageStatus(newMessage, MessageStatus.sent);
        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.body}');
        newMessage.status = MessageStatus.failed;
        updateMessageStatus(newMessage, MessageStatus.failed);
      }
    } catch (e) {
      print('Error sending message: $e');
      newMessage.status = MessageStatus.failed;
      updateMessageStatus(newMessage, MessageStatus.failed);
    }
  }
}
