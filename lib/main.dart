import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shallows/models/UserModel.dart';
import 'package:shallows/screens/lake/LakePage.dart';
import 'package:shallows/screens/authenticate/Register.dart';
import 'package:shallows/screens/authenticate/SignIn.dart';
import 'package:shallows/screens/profile/ProfilePage.dart';
import 'package:shallows/screens/profile/editProfile.dart';
import 'package:shallows/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shallows/services/auth_service.dart';

//top level outside the scope of everything. Receive Message when app is in background
// Future<void> backgroundHandler(RemoteMessage message) async {
//   print(message.data.toString());
//   print(message.notification!.title);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //pass function from above
  //FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
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
      child: MaterialApp(
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
