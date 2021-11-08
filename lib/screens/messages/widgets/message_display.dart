import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/messages/widgets/message_bubble.dart';

class MessageDisplay extends StatefulWidget {
  const MessageDisplay({Key? key}) : super(key: key);

  @override
  _MessageDisplayState createState() => _MessageDisplayState();
}

class _MessageDisplayState extends State<MessageDisplay> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            print('test phrase');
            return Text("Loading.....");
          }
          //if (snapshot.data == )
          var chatDocs = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                chatDocs[index]['text'],
                chatDocs[index]['firstName'],
                chatDocs[index]['lastName'],
                // Bool if is you, right now is always false cause not userID field
                chatDocs[index]['residence'] == currentUser,
                key: ValueKey(chatDocs[index].id),
              );
            },
          );
        });
  }
}
