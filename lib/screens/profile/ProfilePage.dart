//import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//import 'package:provider/provider.dart';
import 'package:shallows/models/UserModel.dart';

//import 'package:shallows/screens/profile/Avatar.dart';
//import 'package:shallows/services/UserCollectionSetup.dart';
//import 'package:shallows/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 200;
  final double profileHeight = 144;
  UserModel userModel = new UserModel();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  static Future<dynamic> loadImage(BuildContext context, String path) async {
    String image =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();

    return image.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
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

  Widget buildProfileImage() => Container(
        width: 200,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.yellow,
            width: 4.0,
          ),
        ),
        child: FutureBuilder(
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
              return CircleAvatar(
                radius: 65,
                child: ClipOval(
                  child: FutureBuilder(
                    future: loadImage(context, '${data['photoURL']}'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CircleAvatar(
                          radius: 65,
                          backgroundImage:
                              NetworkImage(snapshot.data.toString()),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
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

  // Bottom Content

  Widget buildContent() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      //height: height,
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
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 285),
                      child: Text(
                        '${data['firstName']} ${data['lastName']}',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '${data['residence']} Residence',
                        style: TextStyle(
                            fontSize: 18, color: Colors.blueGrey[200]),
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
                        'About Me:',
                        style: TextStyle(fontSize: 21, color: Colors.yellow),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      width: width * .9,
                      margin: const EdgeInsets.all(15),
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      child: data['aboutMe'] == null || data['aboutMe'] == ''
                          ? Text(
                              'Enter Below',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            )
                          : Text(
                              '${data['aboutMe']}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'RaleWay'),
                              maxLines: 4,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.start,
                            ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Personal Best:',
                        style: TextStyle(fontSize: 21, color: Colors.yellow),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: width * .9,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellowAccent.withOpacity(.2),
                        gradient: new LinearGradient(
                          colors: [Colors.yellow, Colors.cyan],
                        ),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: const EdgeInsets.all(15),
                      child: data['personalBest'] == null ||
                              data['personalBest'] == ''
                          ? Text(
                              'Enter Below',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white),
                            )
                          : Text(
                              '${data['personalBest']}',
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ElevatedButton(
                      child: Text('Edit Profile'),
                      onPressed: () {
                        Navigator.pushNamed(context, "/editProfile")
                            .then((_) => setState(() {}));
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Text('loading');
        },
      ),
    );
  }
}
