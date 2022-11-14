import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/messages/chat_controller.dart';
import 'package:shallows/screens/messages/widgets/message_display.dart';
import 'package:shallows/screens/messages/widgets/message_input.dart';

class ChatScreen extends StatelessWidget {
  final String otherResidence;
  // final String lastMessageId;

  ChatScreen({
    required this.otherResidence,
    // required this.lastMessageId,
  });

  final chatController = Get.find<ChatController>();
  final lakeScreenController = Get.find<LakeScreenController>();

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  ScrollController _myScrollController = ScrollController();
  void scrollDown() {
    Timer(
        Duration(milliseconds: 500),
        () => _myScrollController
            .jumpTo(_myScrollController.position.maxScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "The $otherResidence's",
            textScaleFactor: 1,
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Color.fromARGB(255, 41, 47, 63),
        ),
        body: Container(
          color: Color.fromARGB(255, 41, 47, 63),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MessageDisplay(recipient: otherResidence),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: MessageInput(
                  otherResidence,
                  '${lakeScreenController.currentUserSnapshot["residence"]}',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//   Align(
//   alignment: FractionalOffset.bottomCenter,
//   child: MessageInput(
//       '${widget.name}', '${userData['residence']}'),
// )

// children: messageData['from'] == widget.name
// ? Text(messageData['content'])
// : Text('no content')
