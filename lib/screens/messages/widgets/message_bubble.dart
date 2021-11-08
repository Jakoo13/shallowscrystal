import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String firstName;
  final String lastName;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.firstName, this.lastName, this.isMe,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        )
      ],
    );
  }
}
