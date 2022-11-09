import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:shallows/screens/messages/all_messages_tile.dart';
import 'package:shallows/screens/messages/chat_controller.dart';

import 'MessageModel.dart';

class AllMessages extends StatelessWidget {
  const AllMessages({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chatController = Get.put(ChatController());
    var lakeController = Get.put(LakeScreenController());

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
                ),
              );
            },
            itemBuilder: (context) => [
              // popupmenu item 1
              ...lakeController.residencesList.asMap().entries.map((e) {
                int index = e.key;
                var val = e.value;

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
        color: Color.fromRGBO(41, 47, 63, 1),
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.only(
              top: 20,
              bottom: 40,
            ),
            itemCount: chatController.messages.length,
            itemBuilder: (BuildContext context, int index) {
              // print("From Snap: ${chatController.messages[index][0].content}");
              if (chatController.messages[index].isNotEmpty) {
                return AllMessagesTile(
                    content: chatController.messages[index].last.content,
                    otherResidence: lakeController.residencesList[index]
                        ["name"]);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget showMessageTile(data) {
  final lakeController = Get.find<LakeScreenController>();
  final chatController = Get.find<ChatController>();
  print("function ran");
  //Check if residence has already been added to array
  if (chatController.messagesFromAndTo.contains(data["from"]) ||
      chatController.messagesFromAndTo.contains(data["to"])) {
    return SizedBox.shrink();
  }

  if (data["from"] == lakeController.currentUserSnapshot["residence"] ||
      data["to"] == lakeController.currentUserSnapshot["residence"]) {
    //Add the other residence to the array if they haven't already been added
    if (data["from"] != lakeController.currentUserSnapshot["residence"]) {
      chatController.messagesFromAndTo.add(data["from"]);
      return AllMessagesTile(
        otherResidence: data["from"],
        content: data["content"],
      );
    } else {
      chatController.messagesFromAndTo.add(data["to"]);
      return AllMessagesTile(
        otherResidence: data["to"],
        content: data["content"],
      );
    }
  } else {
    return SizedBox.shrink();
  }
}
