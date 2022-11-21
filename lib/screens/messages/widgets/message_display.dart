import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShallowsCrystal/screens/lake/lake_screen_controller.dart';
import 'package:ShallowsCrystal/screens/messages/widgets/message_bubble.dart';

class MessageDisplay extends StatefulWidget {
  final String recipient;
  const MessageDisplay({Key? key, required this.recipient}) : super(key: key);

  @override
  _MessageDisplayState createState() => _MessageDisplayState();
}

class _MessageDisplayState extends State<MessageDisplay> {
  @override
  Widget build(BuildContext context) {
    final lakeController = Get.find<LakeScreenController>();

    return Expanded(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .doc(lakeController.currentUserSnapshot["residence"])
              .collection(widget.recipient)
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading.....");
            }
            //if (snapshot.data == )
            var chatDocs = snapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.only(
                bottom: 20,
              ),
              shrinkWrap: true,
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) {
                bool sentByMe = chatDocs[index]["from"] ==
                    lakeController.currentUserSnapshot["residence"];
                return MessageBubble(
                  chatDocs[index]["content"],
                  sentByMe,
                  chatDocs[index]["timeStamp"],
                );
                // MessageBubble(
                //   chatDocs[index]['text'],
                //   chatDocs[index]['firstName'],
                //   chatDocs[index]['lastName'],
                //   // Bool if is you, right now is always false cause not userID field
                //   chatDocs[index]['residence'] == currentUser,
                //   key: ValueKey(chatDocs[index].id),
                // );
              },
            );
          }),
    );
  }
}
