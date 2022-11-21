import 'package:ShallowsCrystal/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:ShallowsCrystal/models/UserModel.dart';
import 'package:ShallowsCrystal/screens/lake/LakePage.dart';
import 'package:ShallowsCrystal/screens/authenticate/Register.dart';
import 'package:ShallowsCrystal/screens/authenticate/SignIn.dart';
import 'package:ShallowsCrystal/screens/profile/ProfilePage.dart';
import 'package:ShallowsCrystal/screens/profile/editProfile.dart';
import 'package:ShallowsCrystal/screens/wrapper.dart';
import 'package:provider/provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'com.netscaledigital.crystal', 'High Importance Notifications',
    importance: Importance.high, playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//fires when receive notification in background, does not show popup, This Handler must be top level because this works outside of the app when app is in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings iosSettings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  if (iosSettings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (iosSettings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  //final SharedPreferences prefs;
  MyApp();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<UserModel>(
          create: (_) => UserModel(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shallows',
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/login': (context) => SignIn(),
          '/register': (context) => Register(),
          '/lake': (context) => LakePage(),
          '/editProfile': (context) => EditProfile(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
