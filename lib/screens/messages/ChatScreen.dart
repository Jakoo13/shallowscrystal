import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/messages/widgets/message_input.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final int index;
  final String currentUserResidence;
  final String name;
  final String photoURL;
  ChatScreen(this.index, this.currentUserResidence, this.name, this.photoURL);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  // final CollectionReference messages =
  //     FirebaseFirestore.instance.collection('messages');
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
    scrollDown();
    //print(widget.name);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "The ${widget.name}'s",
            textScaleFactor: 1,
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: FutureBuilder(
                  future: users.doc(auth.currentUser!.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.hasData && !snapshot.data!.exists) {
                      return Text('Document does not exist');
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String sortAlphabetically() {
                        final sortedSet = SplayTreeSet.from(
                          {"${userData['residence']}", "${widget.name}"},
                        );
                        print(sortedSet.join());
                        return sortedSet.join('');
                      }

                      return StreamBuilder(
                        stream: fireStore
                            .collection('messages')
                            .doc('${sortAlphabetically()}')
                            .collection('chats')
                            .orderBy('timeStamp', descending: false)
                            .snapshots(),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> chatSnapshot,
                        ) {
                          if (chatSnapshot.hasError) {
                            return Text('Something Went Wrong');
                          }
                          if (chatSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading');
                          }
                          final data = chatSnapshot.requireData;
                          return ListView.builder(
                              controller: _myScrollController,
                              itemCount: data.size,
                              itemBuilder: (context, index) {
                                var from = data.docs[index]['from'];
                                var content = data.docs[index]['content'];
                                var timeStamp = data.docs[index]['timeStamp'];
                                var timeFormatted = timeStamp.toDate();
                                var formattedDate = DateFormat('MM-dd - kk:mm')
                                    .format(timeFormatted);
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          from == userData['residence']
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 8),
                                          constraints:
                                              BoxConstraints(maxWidth: 240),
                                          decoration: BoxDecoration(
                                            color: from == userData['residence']
                                                ? Colors.blue
                                                : Colors.green,
                                            borderRadius:
                                                from == userData['residence']
                                                    ? BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(15),
                                                      )
                                                    : BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(15),
                                                      ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                from == userData['residence']
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                content,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          from == userData['residence']
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: from == userData['residence']
                                              ? const EdgeInsets.only(
                                                  right: 20,
                                                )
                                              : const EdgeInsets.only(left: 20),
                                          child: Text(
                                            formattedDate.toString(),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              });
                        }

                        //return Text('loading');
                        ,
                      );
                    }
                    return Text('loading');
                  }),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: MessageInput(
                '${widget.name}',
                '${widget.currentUserResidence}',
              ),
            )
          ],
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
