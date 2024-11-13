import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hdccapp/module/patient/chat/message_bubble.dart';
import '../../../models/message_model.dart';
import 'chat_controller.dart';

class ChatScreen extends StatefulWidget {

  final String patientId;
  final String doctorId;
  final String? chatId;
  final String doctorName;
  final String doctorPhoto;

  ChatScreen({
    required this.patientId,
    required this.doctorId,
    required this.chatId,
    required this.doctorName,
    required this.doctorPhoto,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ChatController chatController = Get.put(ChatController());
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isSendButtonActive = false;

  @override
  void initState() {
    super.initState();

    // Set the chat ID in the controller if it's an existing chat
    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      chatController.setChatId(widget.chatId!);
    }

    // Listen to changes in messages and scroll to the bottom
    chatController.messages.listen((_) {
      _scrollToBottom();
    });

    _messageController.addListener(_handleMessageInputChange);
  }

  void _handleMessageInputChange() {
    final isNotEmpty = _messageController.text.trim().isNotEmpty;
    if (isSendButtonActive != isNotEmpty) {
      setState(() {
        isSendButtonActive = isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleMessageInputChange);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = widget.doctorPhoto
        ?.replaceAll("127.0.0.1", "192.168.1.4") ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.doctorPhoto.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : AssetImage('assets/images/profile1.jpg') as ImageProvider, // This is causing the error
            ),

            SizedBox(width: 10),
            Text(
              widget.doctorName,
              style: TextStyle(fontFamily: "Poppins", fontSize: 20),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final groupedMessages = _groupMessagesByDate(chatController.messages);
              return ListView.builder(
                controller: _scrollController,
                itemCount: groupedMessages.length,
                itemBuilder: (context, index) {
                  final item = groupedMessages[index];

                  if (item is String) {
                    // Display date headers
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          item,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    );
                  } else if (item is Message) {
                    // Display the message bubbles
                    return MessageBubble(
                      item.content,
                      item.sender,
                      item.sender == 'patient',
                      item.timestamp,
                      item.status,
                    );
                  }
                  return SizedBox();
                },
              );
            }),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintText: 'Type your message...'.tr,
              ),
            ),
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.send),
            color: isSendButtonActive ? Theme.of(context).primaryColor : Colors.grey,
            onPressed: isSendButtonActive ? _handleSendMessage : null,
          ),
        ],
      ),
    );
  }
  void _handleSendMessage() {
    final messageContent = _messageController.text.trim();
    if (messageContent.isEmpty) return;

    // Create a temporary message with "sending" status
    final tempMessage = Message(
      content: messageContent,
      sender: 'patient',
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      isSeen: false,
    );

    print('Attempting to send message: $messageContent');

    // Add the message with "sending" status only once
    //chatController.addMessage(tempMessage);
    _messageController.clear();

    // Send the message
    chatController.sendMessage(
      patientId: widget.patientId,
      doctorId: widget.doctorId,
      content: messageContent,
    ).then((_) {
      // On success, update the message status to "sent"
      print('Message sent successfully: $messageContent');
      chatController.updateMessageStatus(tempMessage, MessageStatus.sent);
    }).catchError((error) {
      // On failure, update the message status to "failed"
      print('Failed to send message: $messageContent, error: $error');
      chatController.updateMessageStatus(tempMessage, MessageStatus.failed);
    });

  }






  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<dynamic> _groupMessagesByDate(List<Message> messages) {
    List<dynamic> groupedMessages = [];
    DateTime? lastDate;

    for (var message in messages) {
      final messageDate = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );

      if (lastDate == null || lastDate != messageDate) {
        String dateHeader;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(Duration(days: 1));

        if (messageDate == today) {
          dateHeader = 'Today';
        } else if (messageDate == yesterday) {
          dateHeader = 'Yesterday';
        } else {
          dateHeader = DateFormat.yMMMMd().format(messageDate);
        }


        groupedMessages.add(dateHeader);
        lastDate = messageDate;
      }

      groupedMessages.add(message);
    }

    return groupedMessages;
  }


}
