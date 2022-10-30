//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:shallows/main.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shallows/screens/home/SkierAnimation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shallows/screens/lake/LakePage.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'package:shallows/screens/settings/SettingsPage.dart';
// import 'package:shallows/screens/messages/allMessages.dart';
// import 'package:shallows/screens/residences/ResidencesPage.dart';
// import 'package:shallows/screens/profile/ProfilePage.dart';
//import 'package:shallows/services/auth_service.dart';
//import 'package:shallows/services/local_notification_service.dart';

Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;
  //String? userEmail = FirebaseAuth.instance.currentUser!.email;

  await FirebaseFirestore.instance.collection('users').doc(userId).update({
    'tokens': token.toString()
    // FieldValue.arrayUnion([token]),
  });
}

Future<void> getFirebaseToken() async {
  // Get the token each time the application loads
  String? token = await FirebaseMessaging.instance.getToken();
  // Save the initial token to the database

  await saveTokenToDatabase(token!);
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getFirebaseToken();
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

    //gives message on which user taps and opens app from terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('opened app from terminated');
      if (message != null) {
        print('received message from terminated: $message');
      }
    });

    // end different video

    //When App is in Foreground, does not show popup, but gets message, does not run when app is in background
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      print('onMessage: $message');
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    });

    //Fires when User CLICKS notification while app only is in background and not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('A new onMessageOpenedApp event was published!: $message');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        print('on message opened app: $message');
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title ?? '-1'),
                content: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.body ?? '-1'),
                  ],
                )),
              );
            });
      }
      //final routeFromMessage = message.data["route"];
      //Navigator.pushNamed(context, routeFromMessage);
    });
  }

  //testing notification onPress of Message Board
  void showNotification() {
    flutterLocalNotificationsPlugin.show(
      0,
      "Testing",
      "Testing Body",
      NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              importance: Importance.high,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher'),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var lakeController = Get.put(LakeScreenController());
    //Get Screen Size of Every Device
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //Get Safe Area of Every Device
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;
    //final AuthService _auth = AuthService();
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
      child: Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
        body: ListView(
          //padding: EdgeInsets.only(bottom: 50),
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 90.0,
                left: 30,
                right: 30,
                bottom: 20,
              ),
              child: Container(
                height: newheight,
                //color: Colors.green,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 0,
                        bottom: 20,
                      ),
                      child: SkierAnimation(),
                      alignment: Alignment.center,
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 50,
                          right: 50,
                          bottom: 40,
                        ),
                        child: Image.asset('assets/LakeFlags.png'),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ListTile(
                        tileColor: Color.fromARGB(255, 255, 235, 59),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        leading: Icon(Icons.assistant_photo),
                        title: Text(
                          'Lake Queue',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.assistant_photo),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.size,
                              alignment: Alignment.bottomCenter,
                              child: LakePage(),
                            ),
                          );
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        print(lakeController.currentUserSnapshot['residence']);
                      },
                      child: Container(
                          width: 100,
                          height: 50,
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              "Test Me",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: users.doc(userId).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Text('Document does not exist');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          bool flagChangeSwitch =
                              userData['flagChangeNotifications'];
                          bool messagesSwitch =
                              userData['messageNotifications'];
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 40.0,
                                  right: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Flag Change Alerts",
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
                                            "flagChangeNotifications":
                                                flagChangeSwitch
                                          }).catchError(
                                              (error) => print(error));
                                        },
                                        activeTrackColor:
                                            Colors.lightGreen[400],
                                        activeColor: Colors.lightGreen[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Message Alerts",
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
                                            "messageNotifications":
                                                messagesSwitch
                                          }).catchError(
                                              (error) => print(error));
                                        },
                                        activeTrackColor:
                                            Colors.lightGreen[400],
                                        activeColor: Colors.lightGreen[200],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          height: 40,
          width: 40,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.grey,
              elevation: 0,
              child: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.size,
                    alignment: Alignment.bottomCenter,
                    child: SettingsPage(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
