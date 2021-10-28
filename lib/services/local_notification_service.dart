import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//In case of background, we do not have to use any other package, we just have to create a channel and specify the channel ID. In case of Foreground, you have to use Flutter Local Notification because Firebase doesn't show the heads up notification while the app is in foreground

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(android: AndroidInitializationSettings(
            // Logo
            '@mipmap/ic_launcher'));
    _notificationsPlugin.initialize(initializationSettings);
  }

  //will be used when app is in foreground, create notification channel
  static void display(RemoteMessage message) async {
    // id should be unique so we can use date time
    try {
      Random random = new Random();
      int randomNumber = random.nextInt(100);

      //have to specify the notification details for each platform, right now we are only doing android
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "shallows",
          "shallows channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await _notificationsPlugin.show(randomNumber, message.notification!.title,
          message.notification!.body, notificationDetails);
    } on Exception catch (e) {
      print(e);
    }
  }
}
