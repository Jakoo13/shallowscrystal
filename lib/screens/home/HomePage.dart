//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:shallows/main.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shallows/screens/home/SkierAnimation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shallows/screens/lake/LakePage.dart';
import 'package:shallows/screens/messages/allMessages.dart';
import 'package:shallows/screens/residences/ResidencesPage.dart';
import 'package:shallows/screens/profile/ProfilePage.dart';
import 'package:shallows/services/auth_service.dart';
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
          iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Get Screen Size of Every Device
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //Get Safe Area of Every Device
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;
    final AuthService _auth = AuthService();

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
                bottom: 0,
              ),
              child: Container(
                height: newheight - 40,
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
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Image.asset('assets/Untitled-3.png'),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.yellow,

                        leading: Icon(Icons.add),
                        title: Text(
                          'Profile',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.done),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomCenter,
                                child: ProfilePage(),
                              ));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.yellow,

                        leading: Icon(Icons.add),
                        title: Text(
                          'Lake Queue',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.done),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomCenter,
                                child: LakePage(),
                              ));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.yellow,

                        leading: Icon(Icons.add),
                        title: Text(
                          'Residences',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.done),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomCenter,
                                child: ResidencesPage(),
                              ));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        tileColor: Colors.yellow,

                        leading: Icon(Icons.add),
                        title: Text(
                          'Messages',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.done),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.bottomCenter,
                                child: AllMessages(),
                              ));
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Log Out'),
                      onPressed: () async {
                        await _auth.logOut();
                        //Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
