import 'package:flutter/material.dart';
import 'package:hdccapp/utlis/global_color.dart';
import 'package:intl/intl.dart';

import '../../../models/message_model.dart'; // For formatting the timestamp

class MessageBubble extends StatelessWidget {
  final String content;
  final String sender;
  final bool isMe; // Indicates if the message is sent by the patient
  final DateTime timestamp;
  final MessageStatus status;

  const MessageBubble(
    this.content,
    this.sender,
    this.isMe,
    this.timestamp,
    this.status, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define colors for patient and doctor messages
    final backgroundColor = isMe ? GlobalColors.mainColor : Colors.grey[200];
    final textColor = isMe ? Colors.white : Colors.black87;

    // Icon to indicate the message status
    IconData statusIcon;
    Color iconColor;

    switch (status) {
      case MessageStatus.sending:
        statusIcon = Icons.access_time; // Clock icon for sending
        iconColor = Colors.grey;
        break;
      case MessageStatus.sent:
        statusIcon = Icons.check_circle; // Checkmark for sent
        iconColor = Colors.green;
        break;
      case MessageStatus.failed:
        statusIcon = Icons.error; // Error icon for failed
        iconColor = Colors.red;
        break;
      default:
        statusIcon = Icons.access_time;
        iconColor = Colors.grey;
    }

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: isMe ? Radius.circular(14) : Radius.zero,
              bottomRight: isMe ? Radius.zero : Radius.circular(14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display message content
              Text(
                content,
                style: TextStyle(
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              // Display message timestamp and status icon
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(width: 5),
                  if (isMe) _buildStatusIcon(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Method to display the appropriate status icon
  Widget _buildStatusIcon() {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time, size: 16, color: Colors.white70);
      case MessageStatus.sent:
        return Icon(Icons.check, size: 16, color: Colors.white70);
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 16, color: Colors.red);
      default:
        return SizedBox.shrink(); // Show nothing if there's no matching status
    }
  }
}
