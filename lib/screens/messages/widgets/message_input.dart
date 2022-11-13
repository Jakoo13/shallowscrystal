import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/messages/chat_controller.dart';

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

  var lakeController = Get.find<LakeScreenController>();

  void _sendMessage() async {
    print('button Pressed');
    var chatController = Get.find<ChatController>();
    //FocusScope.of(context).unfocus();
    chatController.messagesFromAndTo.clear();
    print(chatController.messagesFromAndTo);
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
