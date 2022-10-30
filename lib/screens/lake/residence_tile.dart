import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:intl/intl.dart';

import '../messages/ChatScreen.dart';

class ResidenceTile extends StatelessWidget {
  final int index;
  final QueryDocumentSnapshot data;
  const ResidenceTile({Key? key, required this.index, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lakeScreenController = Get.find<LakeScreenController>();

    //Get Current Time Formatted
    DateTime now = new DateTime.now();
    final DateFormat formatter = DateFormat('jm');
    final String dateFormatted = formatter.format(now);

    return InkWell(
      onTap: () {
        if (data["name"] ==
            lakeScreenController.currentUserSnapshot["residence"]) {
          showDialog(
              context: context,
              builder: (_) => CupertinoAlertDialog(
                    title: Text(
                      "Are you sure?",
                      textScaleFactor: 1,
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("Yes",
                            style: TextStyle(fontSize: 20), textScaleFactor: 1),
                        onPressed: () {
                          lakeScreenController.residences
                              .doc(data["name"])
                              .update({
                            'flagOutTime': dateFormatted,
                          }).catchError((error) => print(error));

                          if (data["flagOut"] == true) {
                            lakeScreenController.changeFlagPosition(
                                false, data["name"]);
                          } else {
                            lakeScreenController.changeFlagPosition(
                                true, data["name"]);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("No",
                            style: TextStyle(fontSize: 20), textScaleFactor: 1),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
        }
      },
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: data['flagOut'] ? Colors.red : Colors.grey,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.whatshot_sharp,
              color: Colors.grey[700],
              size: 28,
            ),
            Text(
              data['name'],
              style: TextStyle(
                fontSize: 19,
                color: Colors.grey[900],
                fontWeight: FontWeight.w700,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      index,
                      lakeScreenController.currentUserSnapshot["residence"],
                      data['name'],
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.message,
                color: Colors.blue[600],
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// userData[
      //                                                           'residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Icon(Icons
      //                                                       .whatshot_sharp)
      //                                                   : IconButton(
      //                                                       icon: new Icon(
      //                                                         Icons.message,
      //                                                         color:
      //                                                             Colors.blue,
      //                                                       ),
      //                                                       onPressed: () {
      //                                                         Navigator.push(
      //                                                           context,
      //                                                           MaterialPageRoute(
      //                                                             builder:
      //                                                                 (context) =>
      //                                                                     ChatScreen(
      //                                                               index,
      //                                                               userData[
      //                                                                   'residence'],
      //                                                               residenceData
      //                                                                       .docs[index]
      //                                                                   [
      //                                                                   'name'],
      //                                                               residenceData
      //                                                                       .docs[index]
      //                                                                   [
      //                                                                   'photoURL'],
      //                                                             ),
      //                                                           ),
      //                                                         );
      //                                                       },
      //                                                     ),