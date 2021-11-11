//import 'dart:html';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shallows/models/UserModel.dart';

import 'package:shallows/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();
  final double coverHeight = 200;
  final double profileHeight = 144;

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference residences =
      FirebaseFirestore.instance.collection('residences');
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<dynamic> loadImage(BuildContext context, String path) async {
    String image =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();

    return image.toString();
  }

  @override
  Widget build(BuildContext context) {
    //UserModel currentUser = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue[700],
      ),
      body: Stack(
        children: [
          buildContent(),
          buildTop(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        buildCoverImage(),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/LakesideEstates.jpg'),
                ),
              ),
              height: coverHeight,
            ),
            Container(
              height: coverHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            )
          ],
        ),
      );

  Widget buildProfileImage() {
    return FutureBuilder(
        future: users.doc(auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text('Document does not exist');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              width: 200,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.yellow,
                  width: 4.0,
                ),
              ),
              child: FutureBuilder(
                future: residences.doc(data['residence']).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text('Document does not exist');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> residenceData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return CircleAvatar(
                      radius: 65,
                      child: ClipOval(
                        child: FutureBuilder(
                          future: loadImage(
                              context, '${residenceData['photoURL']}'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return CircleAvatar(
                                radius: 65,
                                backgroundImage:
                                    NetworkImage(snapshot.data.toString()),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            return Container();
                          },
                        ),
                      ),
                    );
                  }
                  return Text('loading');
                },
              ),
            );
          }
          return Text('loading');
        });
  }
  // Bottom Content

  Widget buildContent() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: users.doc(auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text('Document does not exist');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              height: height * 2,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 58, 123, 213),
                    Color.fromARGB(255, 58, 96, 115),
                  ],
                ),
              ),
              child: FutureBuilder<DocumentSnapshot>(
                future: residences.doc(data['residence']).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Text('Document does not exist');
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return ListView(
                      padding: const EdgeInsets.only(bottom: 50),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 285),
                              child: Text(
                                '${data['name']} Residence',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 25),
                              child: Text(
                                'About',
                                style: TextStyle(
                                    fontSize: 21, color: Colors.yellow),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.yellow,
                                ),
                                color: Colors.yellowAccent.withOpacity(.2),
                                gradient: new LinearGradient(
                                  colors: [Colors.yellow, Colors.cyan],
                                ),
                              ),
                              height: 160,
                              width: width * .9,
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 50),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15, bottom: 15),
                              child:
                                  data['about'] == null || data['about'] == ''
                                      ? Text(
                                          'Press Edit Button Below',
                                          style: TextStyle(
                                              fontSize: 19,
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic),
                                        )
                                      : Text(
                                          '${data['about']}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontFamily: 'RaleWay'),
                                          maxLines: 6,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                        ),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       padding: EdgeInsets.only(top: 20),
                        //       child: Text(
                        //         'Contact:',
                        //         style: TextStyle(
                        //             fontSize: 21, color: Colors.yellow),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       width: width * .9,
                        //       decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.yellow),
                        //         borderRadius: BorderRadius.circular(10),
                        //         color: Colors.yellowAccent.withOpacity(.2),
                        //         gradient: new LinearGradient(
                        //           colors: [Colors.yellow, Colors.cyan],
                        //         ),
                        //       ),
                        //       padding: EdgeInsets.all(10),
                        //       margin: const EdgeInsets.all(15),
                        //       child: data['contact'] == null ||
                        //               data['contact'] == ''
                        //           ? Text(
                        //               'Enter Below',
                        //               style: TextStyle(
                        //                   fontSize: 19,
                        //                   fontStyle: FontStyle.italic,
                        //                   color: Colors.white),
                        //             )
                        //           : Text(
                        //               '${data['contact']}',
                        //               style: TextStyle(
                        //                   fontSize: 19, color: Colors.white),
                        //             ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: Text('Edit Profile'),
                              onPressed: () {
                                Navigator.pushNamed(context, "/editProfile")
                                    .then((_) => setState(() {}));
                              },
                            ),
                            ElevatedButton(
                              child: Text('Log Out'),
                              onPressed: () async {
                                await _auth.logOut();
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Text('loading');
                },
              ),
            );
          }
          return Text('Loading');
        });
  }
}
