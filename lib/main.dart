import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shallows/screens/lake/LakePage.dart';
import 'package:shallows/screens/authenticate/Register.dart';
import 'package:shallows/screens/authenticate/SignIn.dart';
import 'package:shallows/screens/profile/editProfile.dart';
import 'package:shallows/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shallows/services/auth_service.dart';

//import 'models/myUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
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
        },
      ),
    );
  }
}
