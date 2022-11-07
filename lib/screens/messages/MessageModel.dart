import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String from;
  final String to;
  final String content;
  final Timestamp timeStamp;
  final bool read;

  Message({
    required this.from,
    required this.to,
    required this.content,
    required this.timeStamp,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'timeStamp': timeStamp,
      'read': read,
    };
  }

  Message.fromMap(Map<String, dynamic> messageMap)
      : from = messageMap["from"],
        to = messageMap["to"],
        content = messageMap["content"],
        timeStamp = messageMap["timeStamp"],
        read = messageMap["read"];
}
