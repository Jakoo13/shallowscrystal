import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:shallows/screens/messages/chat_controller.dart';
import 'package:intl/intl.dart';

class AllMessagesTile extends StatelessWidget {
  final String otherResidence;
  final String content;
  final Timestamp date;
  AllMessagesTile({
    required this.otherResidence,
    required this.content,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    DateTime fromTimeStamp = DateTime.parse(date.toDate().toString());
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String dateFormatted = formatter.format(fromTimeStamp);
    return InkWell(
      onTap: () {
        Get.to(ChatScreen(
          otherResidence: otherResidence,
        ));
      },
      child: Container(
        padding: const EdgeInsets.only(
          top: 22,
          bottom: 22,
          left: 20,
          right: 10,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 124, 112, 112),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              margin: const EdgeInsets.only(
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 124, 112, 112),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 30,
                ),
              ),
            ),
            //Middle Column with Residence and Content
            Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Text(
                      otherResidence,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Roboto",
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${content.substring(0, min(content.length, 25))}",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        content.length > 25 ? "..." : "",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Roboto",
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              dateFormatted,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Roboto",
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
