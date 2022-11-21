import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShallowsCrystal/screens/lake/lake_screen_controller.dart';

//Only a statuful widget because if its not the input state is not saved when switching to emoji's or closing the keyboard
class MessageInput extends StatefulWidget {
  final String? sentTo;
  final String? sentFrom;

  MessageInput(
    this.sentTo,
    this.sentFrom,
  );

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  var _messageString = '';

  var _messageController = TextEditingController();

  var lakeController = Get.find<LakeScreenController>();

  void _sendMessage() async {
    //Add to the sending users messages
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("${widget.sentTo}")
        .doc()
        .set({
      'content': _messageString,
      'from': widget.sentFrom,
      'to': widget.sentTo,
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Add to the receiving users messages
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.sentTo)
        .collection(lakeController.currentUserSnapshot["residence"])
        .doc()
        .set({
      'content': _messageString,
      'from': widget.sentFrom,
      'to': widget.sentTo,
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Add to recents collection in order to show most recent messages in AllMessagesScreen
    await FirebaseFirestore.instance
        .collection('mostRecentMessages')
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("fromAndTo")
        .doc("${widget.sentTo}")
        .set({
      'content': _messageString,
      'residenceFrom': lakeController.currentUserSnapshot["residence"],
      'timeStamp': Timestamp.now(),
      'read': false
    });
    //Do the same thing for the receiving user
    await FirebaseFirestore.instance
        .collection('mostRecentMessages')
        .doc("${widget.sentTo}")
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
              keyboardType: TextInputType.text,
              controller: _messageController,
              maxLines: 1,
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
