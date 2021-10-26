import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shallows/screens/home/HomePage.dart';
import 'package:shallows/screens/authenticate/SignIn.dart';
import 'package:shallows/models/UserModel.dart';
import 'package:shallows/services/auth_service.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
        stream: authService.userStream,
        builder: (_, AsyncSnapshot<UserModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final UserModel? userModel = snapshot.data;
            return userModel == null ? SignIn() : HomePage();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
