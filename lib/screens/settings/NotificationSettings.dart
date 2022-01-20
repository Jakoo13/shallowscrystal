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
              bool notificationsSwitch = userData['notifications'];
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
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Notifications On/Off",
                            textScaleFactor: 1.5,
                            style: TextStyle(
                              color: Colors.yellow,
                              fontSize: 16,
                            ),
                          ),
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: notificationsSwitch,
                              onChanged: (bool value) {
                                setState(() {
                                  notificationsSwitch = value;
                                  print(notificationsSwitch);
                                });
                                users
                                    .doc(userId)
                                    .update(
                                        {"notifications": notificationsSwitch})
                                    .then((value) =>
                                        print("Notifications Update"))
                                    .catchError((error) => print(error));
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.yellow,
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