//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shallows/main.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shallows/screens/home/SkierAnimation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shallows/screens/lake/LakePage.dart';
import 'package:shallows/screens/residences/ResidencesPage.dart';
import 'package:shallows/screens/profile/ProfilePage.dart';
//import 'package:shallows/services/local_notification_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    //different Video
    //gives message on which user taps and opens app from terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print('opened app from terminated');
      if (message != null) {
        print('received message from terminated');
      }
    });

    // end different video

    //When App is in Foreground, does not show popup, but gets message, does not run when app is in background
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
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
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
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
                          'Message Board',
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        trailing: Icon(Icons.done),
                        //subtitle: Text('This is subtitle'),
                        selected: false,
                        onTap: () {
                          showNotification();
                        },
                      ),
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
