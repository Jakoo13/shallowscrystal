import 'package:flutter/material.dart';
import 'package:shallows/screens/home/skier-animation.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shallows/screens/lake_page/lake.dart';
import 'package:shallows/services/auth_service.dart';

class HomePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 90.0,
                left: 30,
                right: 30,
                bottom: 10,
              ),
              child: Container(
                height: 700,
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
                        onTap: () {},
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
                                child: Lake(),
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
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  child: Text('Log Out'),
                  onPressed: () async {
                    await _auth.logOut();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
