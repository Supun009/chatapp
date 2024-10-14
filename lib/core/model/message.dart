// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class Message {
  final String id;
  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;
  int? isRead;
  int? isDeleverd;

  Message({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    this.isRead = 0,
    this.isDeleverd = 0,
  });

  // Method to format and show only the time
  String getFormattedTime() {
    // Choose the format you prefer: 24-hour or 12-hour
    return DateFormat('hh:mm a').format(timestamp); // 12-hour format with AM/PM
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'].toString(),
      sender: map['sender'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      receiver: map['receiver'] ?? '',
      isDeleverd: map['isDeleverd'] ?? 0,
      isRead: map['isRead'] ?? 0,
    );
  }

  Message copyWith({
    String? id,
    String? sender,
    String? receiver,
    String? message,
    DateTime? timestamp,
    int? isRead,
    int? isDeleverd,
  }) {
    return Message(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isDeleverd: isDeleverd ?? this.isDeleverd,
    );
  }
}
