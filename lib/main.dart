import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shallows/screens/lake_page/lake.dart';
import 'package:shallows/screens/authenticate/register.dart';
import 'package:shallows/screens/authenticate/sign_in.dart';
import 'package:shallows/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:shallows/services.dart/auth_service.dart';
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
          '/lake': (context) => Lake(),
        },
      ),
    );
  }
}
