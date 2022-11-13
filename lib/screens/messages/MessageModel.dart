import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Message {
  final String from;
  final String to;
  final String content;
  final Timestamp timeStamp;
  final bool read;
  final String docId;

  Message({
    required this.from,
    required this.to,
    required this.content,
    required this.timeStamp,
    required this.read,
    required this.docId,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'timeStamp': timeStamp,
      'read': read,
      'docId': docId,
    };
  }

  Message.fromMap(Map<String, dynamic> messageMap)
      : docId = messageMap["docId"] ?? Uuid().v4(),
        from = messageMap["from"],
        to = messageMap["to"],
        content = messageMap["content"],
        timeStamp = messageMap["timeStamp"],
        read = messageMap["read"];
}
