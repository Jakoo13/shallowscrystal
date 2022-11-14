import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:intl/intl.dart';
import 'package:shallows/screens/messages/chat_controller.dart';

import '../lake/lake_screen_controller.dart';

class AllMessagesTile extends StatelessWidget {
  final String otherResidence;
  final String content;
  final Timestamp date;
  final bool read;
  final String lastMessageFrom;
  // final String lastMessageId;

  AllMessagesTile({
    required this.otherResidence,
    required this.content,
    required this.date,
    required this.read,
    required this.lastMessageFrom,
    // required this.lastMessageId,
  });

  @override
  Widget build(BuildContext context) {
    var lakeController = Get.find<LakeScreenController>();
    var chatController = Get.find<ChatController>();
    DateTime fromTimeStamp = DateTime.parse(date.toDate().toString());
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    final String dateFormatted = formatter.format(fromTimeStamp);
    var currentUser = lakeController.currentUserSnapshot["residence"];
    return InkWell(
      onTap: () {
        Get.to(
          ChatScreen(
            otherResidence: otherResidence,
          ),
        );
        //Update read status to true if the last message you received and didn't send
        if (lastMessageFrom != currentUser) {
          chatController.updateReadStatus(otherResidence);
        }
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
                    child: read == false &&
                            lastMessageFrom !=
                                lakeController.currentUserSnapshot["residence"]
                        ? Row(
                            children: [
                              Text(
                                otherResidence,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Roboto",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.circle_notifications,
                                color: Colors.red,
                              ),
                            ],
                          )
                        : Text(
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
