import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/models/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _aboutMeController = new TextEditingController();
  TextEditingController _personalBestController = new TextEditingController();
  UserModel userModel = new UserModel();
  ImagePicker picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  //File? file;

  Future uploadPhoto() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    final path = result!.path;

    File? file = File(path);
    try {
      final fileName = basename(file.path);
      final destination = 'profilePhotos/$fileName';
      final ref = storage.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // Future uploadFile() async {
  //   try {
  //     final fileName = basename(file!.path);
  //     final destination = 'files/$fileName';
  //     final ref = storage.ref(destination);
  //     return ref.putFile(file!);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Edit Profile'),
      //   elevation: 0,
      //   backgroundColor: Colors.blue[100],
      // ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        // height: height,
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
                              uploadPhoto();
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
                                      child: Image.network(
                                          'https://scontent.fphx1-1.fna.fbcdn.net/v/t1.6435-9/135292659_10159211270053960_6003474687665634357_n.jpg?_nc_cat=106&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=KyBbHvICSNwAX86hx3d&_nc_ht=scontent.fphx1-1.fna&oh=b05c4c5d5d68c083ae5bb0ee5b96217e&oe=618BB1B7'),
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder<DocumentSnapshot>(
                        future: users.doc(auth.currentUser!.uid).get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text("Document does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Container(
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
                                              maxLength: 140,
                                              maxLines: 4,
                                              controller: _aboutMeController
                                                ..text = '${data['aboutMe']}',
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white70,
                                                helperText: "About Me",
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
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, right: 15.0),
                                            child: TextField(
                                              maxLength: 30,
                                              maxLines: 1,
                                              controller: _personalBestController
                                                ..text =
                                                    '${data['personalBest']}',
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.white70,
                                                helperText: "Personal Best",
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
                                            userModel.aboutMe =
                                                _aboutMeController.text;
                                            users
                                                .doc(auth.currentUser!.uid)
                                                .update({
                                                  'aboutMe':
                                                      _aboutMeController.text,
                                                  'personalBest':
                                                      _personalBestController
                                                          .text,
                                                })
                                                .then((value) =>
                                                    print('Profile Updated'))
                                                .catchError(
                                                    (error) => print(error));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Text('Loading');
                        }),
                  ],
                ),
              );
            }
            return Text('loading');
          },
        ),
      ),
    );
  }
}
