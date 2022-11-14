import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool sentByMe;
  final Timestamp time;

  MessageBubble(
    this.message,
    this.sentByMe,
    this.time,
  );

  @override
  Widget build(BuildContext context) {
    //Convert TimeStamp to formatted date and time
    DateTime fromTimeStamp = DateTime.parse(time.toDate().toString());
    final DateFormat formatter = DateFormat('hh:mm a MMM dd');
    final String dateFormatted = formatter.format(fromTimeStamp);
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
          padding: EdgeInsets.all(12),
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
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  dateFormatted,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
