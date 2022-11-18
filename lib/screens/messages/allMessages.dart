import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:shallows/screens/messages/all_messages_tile.dart';
import 'package:shallows/screens/messages/chat_controller.dart';

class AllMessages extends StatelessWidget {
  const AllMessages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lakeController = Get.put(LakeScreenController());
    var chatController = Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messages",
          style: TextStyle(
            fontSize: 28,
            fontFamily: "Roboto",
          ),
        ),
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              Get.to(
                () => ChatScreen(
                  otherResidence: lakeController.residencesList[value]["name"],
                  // lastMessageId: '',
                ),
              );
            },
            itemBuilder: (context) => [
              // popupmenu item 1
              ...lakeController.residencesList.asMap().entries.map((e) {
                int index = e.key;

                var val = e.value;
                if (val["name"] !=
                    lakeController.currentUserSnapshot["residence"]) {
                  return PopupMenuItem(
                      value: index,
                      // row has two child icon and text.
                      child: Row(
                        children: [
                          Icon(Icons.star),
                          SizedBox(
                            // sized box with width 10
                            width: 10,
                          ),
                          Text(val["name"])
                        ],
                      ));
                }
                return PopupMenuItem(
                  child: SizedBox.shrink(),
                  height: 0,
                );
              }),
            ],
            offset: Offset(0, 100),
            color: Colors.grey,
            elevation: 2,
          ),
        ],
        backgroundColor: Color.fromARGB(255, 41, 47, 63),
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 41, 47, 63),
              Color.fromARGB(255, 32, 55, 66),
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
            stream: chatController.mostRecentMessagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 40,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var messageData = snapshot.data!.docs;

                  if (snapshot.data!.docs.length > 0) {
                    return AllMessagesTile(
                      content: messageData[index]["content"],
                      otherResidence: messageData[index].id,
                      date: messageData[index]["timeStamp"],
                      read: messageData[index]["read"],
                      lastMessageFrom: messageData[index]["residenceFrom"],
                      // lastMessageId: chatController.messages[index].last.docId,
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            }),
      ),
    );
  }
}

///*** JAKE COMMENTED THIS -- Maybe Delete later
// Widget showMessageTile(data) {
//   final lakeController = Get.find<LakeScreenController>();
//   final chatController = Get.find<ChatController>();
//   print("function ran");
//   //Check if residence has already been added to array
//   if (chatController.messagesFromAndTo.contains(data["from"]) ||
//       chatController.messagesFromAndTo.contains(data["to"])) {
//     return SizedBox.shrink();
//   }

//   if (data["from"] == lakeController.currentUserSnapshot["residence"] ||
//       data["to"] == lakeController.currentUserSnapshot["residence"]) {
//     //Add the other residence to the array if they haven't already been added
//     if (data["from"] != lakeController.currentUserSnapshot["residence"]) {
//       chatController.messagesFromAndTo.add(data["from"]);
//       return AllMessagesTile(
//         otherResidence: data["from"],
//         content: data["content"],
//       );
//     } else {
//       chatController.messagesFromAndTo.add(data["to"]);
//       return AllMessagesTile(
//         otherResidence: data["to"],
//         content: data["content"],
//       );
//     }
//   } else {
//     return SizedBox.shrink();
//   }
// }
