import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/messages/chat_controller.dart';
import 'package:uuid/uuid.dart';

class MessageInput extends StatelessWidget {
  final String? sentTo;
  final String? sentFrom;

  MessageInput(
    this.sentTo,
    this.sentFrom,
  );

  var _messageString = '';
  var _messageController = TextEditingController();

  var lakeController = Get.find<LakeScreenController>();

  void _sendMessage() async {
    //Add to the sending users messages
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("$sentTo")
        .doc()
        .set({
      'content': _messageString,
      'from': sentFrom,
      'to': sentTo,
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Add to the receiving users messages
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(sentTo)
        .collection(lakeController.currentUserSnapshot["residence"])
        .doc()
        .set({
      'content': _messageString,
      'from': sentFrom,
      'to': sentTo,
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Add to recents collection in order to show most recent messages in AllMessagesScreen
    await FirebaseFirestore.instance
        .collection('mostRecentMessages')
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("fromAndTo")
        .doc("$sentTo")
        .set({
      'content': _messageString,
      'residenceFrom': lakeController.currentUserSnapshot["residence"],
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Do the same thing for the receiving user
    await FirebaseFirestore.instance
        .collection('mostRecentMessages')
        .doc("$sentTo")
        .collection("fromAndTo")
        .doc(lakeController.currentUserSnapshot["residence"])
        .set({
      'content': _messageString,
      'residenceFrom': lakeController.currentUserSnapshot["residence"],
      'timeStamp': Timestamp.now(),
      'read': false
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: WidgetsBinding.instance.window.viewInsets.bottom > 0.0
          ? EdgeInsets.only(left: 15.0, right: 12, bottom: 15)
          : EdgeInsets.only(left: 15.0, right: 12, bottom: 35),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                _messageString = val;
              },
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 187, 193, 213),
                hintText: 'Send Message',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
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
