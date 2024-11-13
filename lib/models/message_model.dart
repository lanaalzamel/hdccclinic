enum MessageStatus { sending, sent, failed }

class Message {
  final String content;
  final String sender; // Holds either "patient" or "doctor"
  final DateTime timestamp;
  final bool isSeen;
  final DateTime? readAt;
  MessageStatus status;

  Message({
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.isSeen,
    this.readAt,
    this.status = MessageStatus.sending,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    // Determine the sender based on the `from_to` field
    String sender = json['from_to'] == 'doctor' ? 'doctor' : 'patient';

    return Message(
      content: json['content'] ?? '',
      sender: sender,
      timestamp: DateTime.parse(json['created_at']),
      isSeen: json['is_seen'] == 1,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      status: MessageStatus.sent,
    );
  }

  @override
  String toString() {
    return 'Message(content: $content, sender: $sender, timestamp: $timestamp, status: ${status.toString().split('.').last},)';
  }
  // Copy with method
  Message copyWith({
    String? content,
    String? sender,
    DateTime? timestamp,
    MessageStatus? status,
    bool? isSeen,
  }) {
    return Message(
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  @override
  List<Object?> get props => [content, sender, timestamp, status, isSeen];
}