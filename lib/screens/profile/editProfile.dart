import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference residences =
      FirebaseFirestore.instance.collection('residences');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _aboutMeController = new TextEditingController();
  //TextEditingController _contactController = new TextEditingController();

  ImagePicker picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;

  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future uploadPhoto(residence) async {
    final result = await picker.getImage(source: ImageSource.gallery);
    if (result == null) return;
    final path = result.path;

    File file = File(path);
    try {
      final fileName = basename(file.path);
      final destination = 'profilePhotos/$fileName';
      final ref = storage.ref(destination);
      FirebaseFirestore.instance
          .collection('residences')
          .doc(residence)
          .update({"photoURL": destination})
          .then((value) => print('Profile Updated'))
          .catchError((error) => print("Jake's error: $error"));

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<dynamic> loadImage(BuildContext context, String path) async {
    String image =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();
    print(image.toString());
    return image.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
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
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Container(
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
                  future: residences.doc(userData['residence']).get(),
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
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      uploadPhoto(userData['residence']);
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 200,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: new Border.all(
                                              color: Colors.yellow,
                                              width: 4.0,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 65,
                                            child: ClipOval(
                                              child: FutureBuilder(
                                                future: loadImage(context,
                                                    '${data['photoURL']}'),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return CircleAvatar(
                                                      radius: 65,
                                                      backgroundImage:
                                                          NetworkImage(snapshot
                                                              .data
                                                              .toString()),
                                                    );
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  }

                                                  return Container();
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          //top: 1,
                                          bottom: 0,
                                          //right: 0,
                                          left: 120,

                                          child: ClipOval(
                                            child: Container(
                                              color: Colors.yellow,
                                              padding: EdgeInsets.all(3),
                                              child: ClipOval(
                                                child: Container(
                                                  color: Colors.blue,
                                                  padding: EdgeInsets.all(8),
                                                  child: Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 165,
                                          child: Text(
                                            'Edit',
                                            style:
                                                TextStyle(color: Colors.yellow),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 35),
                                  child: Text(
                                    '${userData['residence']} Residence',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .8,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0, bottom: 5),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Update Profile',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(Icons.cancel),
                                          color: Colors.limeAccent[700],
                                          iconSize: 25,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 15.0,
                                                top: 5,
                                                bottom: 20),
                                            child: TextField(
                                              maxLength: 200,
                                              maxLines: 5,
                                              controller: _aboutMeController
                                                ..text = data['about'] != null
                                                    ? '${data['about']}'
                                                    : '',
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white70,
                                                helperText: "About Us",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Padding(
                                    //         padding: const EdgeInsets.only(
                                    //             top: 10, right: 15.0),
                                    //         child: TextField(
                                    //           maxLength: 30,
                                    //           maxLines: 1,
                                    //           controller: _contactController
                                    //             ..text = data['contact'] != null
                                    //                 ? '${data['contact']}'
                                    //                 : '',
                                    //           decoration: InputDecoration(
                                    //             filled: true,
                                    //             fillColor: Colors.white70,
                                    //             helperText: "Contact",
                                    //             border: OutlineInputBorder(
                                    //               borderRadius:
                                    //                   BorderRadius.circular(10),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          child: Text('Save'),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.limeAccent[700],
                                            onPrimary: Colors.black87,
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onPressed: () async {
                                            residences
                                                .doc(userData['residence'])
                                                .update({
                                                  'about':
                                                      _aboutMeController.text,
                                                  // 'contact':
                                                  //     _contactController.text,
                                                })
                                                .then((value) =>
                                                    print('Profile Updated'))
                                                .catchError(
                                                    (error) => print(error));

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Text('loading');
                  },
                ),
              );
            }
            return Text('Loading');
          }),
    );
  }
}
