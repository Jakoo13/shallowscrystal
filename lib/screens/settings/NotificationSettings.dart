import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({Key? key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 58, 123, 213),
            Color.fromARGB(255, 58, 96, 115),
          ],
        ),
      ),
      child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(userId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text('Document does not exist');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              bool flagChangeSwitch = userData['flagChangeNotifications'];
              bool messagesSwitch = userData['messageNotifications'];
              return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(
                    "Notifications",
                    textScaleFactor: 1.2,
                  ),
                  elevation: 0,
                ),
                body: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        top: 60.0,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              "Flag Change Notifications",
                              textScaleFactor: 1.5,
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: flagChangeSwitch,
                              onChanged: (bool value) {
                                setState(() {
                                  flagChangeSwitch = value;
                                });
                                users.doc(userId).update({
                                  "flagChangeNotifications": flagChangeSwitch
                                }).catchError((error) => print(error));
                              },
                              activeTrackColor: Colors.lightGreen[400],
                              activeColor: Colors.lightGreen[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 60.0,
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: Text(
                              "Message Notifications",
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: messagesSwitch,
                              onChanged: (bool value) {
                                setState(() {
                                  messagesSwitch = value;
                                });
                                users.doc(userId).update({
                                  "messageNotifications": messagesSwitch
                                }).catchError((error) => print(error));
                              },
                              activeTrackColor: Colors.lightGreen[400],
                              activeColor: Colors.lightGreen[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
                                                                    // onPressed:
                                                                    //       () {
                                                                    //     residences
                                                                    //         .doc(residenceData.docs[index].id)
                                                                    //         .update({
                                                                    //           'flagOutTime': dateFormatted,
                                                                    //         })
                                                                    //         .then((value) => print('Profile Updated'))
                                                                    //         .catchError((error) => print(error));
                                                                    //     print(residenceData
                                                                    //         .docs[index]
                                                                    //         .id);
                                                                    //     if (flagOut ==
                                                                    //         true) {
                                                                    //       _database.changeFlagPosition(
                                                                    //           false,
                                                                    //           residenceData.docs[index].id);
                                                                    //     } else {
                                                                    //       _database.changeFlagPosition(
                                                                    //           true,
                                                                    //           residenceData.docs[index].id);
                                                                    //     }
                                                                    //     Navigator.of(context)
                                                                    //         .pop();
                                                                    //   },