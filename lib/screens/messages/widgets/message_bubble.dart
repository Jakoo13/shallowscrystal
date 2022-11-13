import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;

  final bool sentByMe;
  // final Key key;

  MessageBubble(
    this.message,
    this.sentByMe,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .8),
          margin: EdgeInsets.only(
            top: 8,
            left: 10,
            right: 10,
          ),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: sentByMe ? Colors.blue : Color.fromARGB(255, 140, 149, 161),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Flexible(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        )
      ],
    );
  }
}
