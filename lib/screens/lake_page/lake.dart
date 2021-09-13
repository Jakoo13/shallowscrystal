import 'package:flutter/material.dart';
import 'package:shallows/services.dart/auth_service.dart';

import 'lake_view.dart';

class Lake extends StatefulWidget {
  static String id = 'lake';
  const Lake({Key? key}) : super(key: key);

  @override
  _LakeState createState() => _LakeState();
}

class _LakeState extends State<Lake> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lake Page'),
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: () async {
              await _auth.logOut();
            },
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        color: Color(0xFF2D2F41),
        child: LakeView(),
      ),
    );
  }
}
