import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final String? sentTo;
  final String? sentFrom;

  MessageInput(
    this.sentTo,
    this.sentFrom,
  );
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  var _messageString = '';
  var _messageController = TextEditingController();

  String sortAlphabetically() {
    final sortedSet = SplayTreeSet.from(
      {"${widget.sentFrom}", "${widget.sentTo}"},
    );
    print(sortedSet.join());
    return sortedSet.join('');
  }

  void _sendMessage() async {
    print('button Pressed');

    //FocusScope.of(context).unfocus();

    await FirebaseFirestore.instance
        .collection('messages/${sortAlphabetically()}/chats')
        .doc()
        .set({
      'content': _messageString,
      'from': widget.sentFrom,
      'to': widget.sentTo,
      'timeStamp': Timestamp.now(),
      'read': "false"
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                _messageString = val;
              },
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Send Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => {_sendMessage()},
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
