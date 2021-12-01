import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:shallows/services/database.dart';
import 'package:intl/intl.dart';

class LakePage extends StatefulWidget {
  static String id = 'LakePage';
  const LakePage({Key? key}) : super(key: key);

  @override
  _LakePageState createState() => _LakePageState();
}

class _LakePageState extends State<LakePage> {
  final DatabaseService _database = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    //Get Current Time Formatted
    DateTime now = new DateTime.now();
    final DateFormat formatter = DateFormat('jm');
    final String dateFormatted = formatter.format(now);

    //Get Screen Size of Every Device
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    //Get Safe Area of Every Device
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference residences =
        FirebaseFirestore.instance.collection('residences');

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> userData =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Scaffold(
                appBar: AppBar(
                  title: Text('Lake Queue'),
                  elevation: 0,
                  backgroundColor: Colors.lightBlue[700],
                ),
                body: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 10),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            height: newheight * .84,
                            padding: const EdgeInsets.only(top: 10),
                            child: StreamBuilder<QuerySnapshot>(
                                stream: _database.residenceSnapshot,
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot,
                                ) {
                                  if (snapshot.hasError) {
                                    return Text('Something Went Wrong');
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // return Text('Loading');
                                  }
                                  final residenceData = snapshot.requireData;

                                  return ListView.builder(
                                      itemCount: residenceData.size,
                                      itemBuilder: (context, index) {
                                        var flagOut = residenceData.docs[index]
                                            ['flagOut'];
                                        String sortAlphabetically() {
                                          final sortedSet = SplayTreeSet.from(
                                            {
                                              "${userData['residence']}",
                                              "${residenceData.docs[index]['name']}"
                                            },
                                          );

                                          return sortedSet.join('');
                                        }

                                        return StreamBuilder(
                                            stream: fireStore
                                                .collection('messages')
                                                .doc('${sortAlphabetically()}')
                                                .collection('chats')
                                                .orderBy('timeStamp',
                                                    descending: false)
                                                .snapshots(),
                                            builder: (
                                              context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  chatSnapshot,
                                            ) {
                                              if (chatSnapshot.hasError) {
                                                return Text(
                                                    'Something Went Wrong');
                                              }
                                              if (chatSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }

                                              if (chatSnapshot.hasData) {
                                                if (chatSnapshot
                                                        .data!.docs.length ==
                                                    0) {
                                                  return Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: ListTile(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      enabled: userData[
                                                                  'residence'] ==
                                                              residenceData
                                                                      .docs[
                                                                  index]['name']
                                                          ? true
                                                          : false,
                                                      tileColor: userData[
                                                                  'residence'] ==
                                                              residenceData
                                                                      .docs[
                                                                  index]['name']
                                                          ? Colors.white
                                                          : Colors.teal[200],
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder: (_) =>
                                                                CupertinoAlertDialog(
                                                                  title: Text(
                                                                    "Change Flag Position?",
                                                                    textScaleFactor:
                                                                        1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      child: Text(
                                                                          "Yes",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                                  20),
                                                                          textScaleFactor:
                                                                              1),
                                                                      onPressed:
                                                                          () {
                                                                        residences
                                                                            .doc(residenceData.docs[index].id)
                                                                            .update({
                                                                              'flagOutTime': dateFormatted,
                                                                            })
                                                                            .then((value) => print('Profile Updated'))
                                                                            .catchError((error) => print(error));
                                                                        print(residenceData
                                                                            .docs[index]
                                                                            .id);
                                                                        if (flagOut ==
                                                                            true) {
                                                                          _database.changeFlagPosition(
                                                                              false,
                                                                              residenceData.docs[index].id);
                                                                        } else {
                                                                          _database.changeFlagPosition(
                                                                              true,
                                                                              residenceData.docs[index].id);
                                                                        }
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      child: Text(
                                                                          "No",
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                                  20),
                                                                          textScaleFactor:
                                                                              1),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    )
                                                                  ],
                                                                ));
                                                      },
                                                      leading: flagOut
                                                          ? Icon(
                                                              Icons
                                                                  .flag_outlined,
                                                              color:
                                                                  Colors.black)
                                                          : Icon(Icons
                                                              .whatshot_sharp),
                                                      trailing: userData[
                                                                  'residence'] ==
                                                              residenceData
                                                                      .docs[
                                                                  index]['name']
                                                          ? Icon(Icons
                                                              .whatshot_sharp)
                                                          : IconButton(
                                                              icon: new Icon(
                                                                Icons.message,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ChatScreen(
                                                                      index,
                                                                      userData[
                                                                          'residence'],
                                                                      residenceData
                                                                              .docs[index]
                                                                          [
                                                                          'name'],
                                                                      residenceData
                                                                              .docs[index]
                                                                          [
                                                                          'photoURL'],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                      selected: residenceData
                                                              .docs[index]
                                                          ['flagOut'],
                                                      selectedTileColor: userData[
                                                                  'residence'] ==
                                                              residenceData
                                                                      .docs[
                                                                  index]['name']
                                                          ? Colors.yellow
                                                          : Colors.redAccent,
                                                      title: Text(
                                                        '${residenceData.docs[index]['name']}:  Flag ${flagOut ? "Out" : "In"}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[900],
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 19,
                                                        ),
                                                        textScaleFactor: 1,
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          flagOut
                                                              ? Text(
                                                                  'At ' +
                                                                      residenceData
                                                                              .docs[index]
                                                                          [
                                                                          'flagOutTime'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  textScaleFactor:
                                                                      1,
                                                                )
                                                              : Text(''),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                              final messageData =
                                                  chatSnapshot.data;
                                              //Getting the last message and that document reference to use to update the field of "read"
                                              final count =
                                                  messageData!.docs.length;

                                              final stringSplit = messageData
                                                  .docs[count - 1].reference
                                                  .toString()
                                                  .split("/");
                                              final docRefWithParenthesis =
                                                  stringSplit[3];
                                              final docRef =
                                                  docRefWithParenthesis
                                                      .substring(
                                                          0,
                                                          docRefWithParenthesis
                                                                  .length -
                                                              1);
                                              print(messageData.docs[count - 1]
                                                  ['read']);
                                              return Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: ListTile(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  enabled: userData[
                                                              'residence'] ==
                                                          residenceData
                                                                  .docs[index]
                                                              ['name']
                                                      ? true
                                                      : false,
                                                  tileColor: userData[
                                                              'residence'] ==
                                                          residenceData
                                                                  .docs[index]
                                                              ['name']
                                                      ? Colors.white
                                                      : Colors.teal[200],
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            CupertinoAlertDialog(
                                                              title: Text(
                                                                "Change Flag Position?",
                                                                textScaleFactor:
                                                                    1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  child: Text(
                                                                      "Yes",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                      textScaleFactor:
                                                                          1),
                                                                  onPressed:
                                                                      () {
                                                                    residences
                                                                        .doc(residenceData
                                                                            .docs[
                                                                                index]
                                                                            .id)
                                                                        .update({
                                                                          'flagOutTime':
                                                                              dateFormatted,
                                                                        })
                                                                        .then((value) =>
                                                                            print(
                                                                                'Profile Updated'))
                                                                        .catchError((error) =>
                                                                            print(error));
                                                                    print(residenceData
                                                                        .docs[
                                                                            index]
                                                                        .id);
                                                                    if (flagOut ==
                                                                        true) {
                                                                      _database.changeFlagPosition(
                                                                          false,
                                                                          residenceData
                                                                              .docs[index]
                                                                              .id);
                                                                    } else {
                                                                      _database.changeFlagPosition(
                                                                          true,
                                                                          residenceData
                                                                              .docs[index]
                                                                              .id);
                                                                    }
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                CupertinoDialogAction(
                                                                  child: Text(
                                                                      "No",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                      textScaleFactor:
                                                                          1),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                )
                                                              ],
                                                            ));
                                                  },
                                                  // messageData.docs[
                                                  //                 count - 1]
                                                  //             ['read'] ==
                                                  //         "false"
                                                  //     ?
                                                  leading: flagOut
                                                      ? Icon(Icons.flag_rounded,
                                                          color: Colors.black)
                                                      : Icon(
                                                          Icons.whatshot_sharp),
                                                  trailing: userData[
                                                              'residence'] ==
                                                          residenceData
                                                                  .docs[index]
                                                              ['name']
                                                      ? Icon(
                                                          Icons.whatshot_sharp)
                                                      : IconButton(
                                                          icon: new Icon(
                                                            Icons.message,
                                                            color: Colors.blue,
                                                          ),
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'messages/${sortAlphabetically()}/chats')
                                                                .doc(docRef)
                                                                .update({
                                                              'read': "true"
                                                            });
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ChatScreen(
                                                                  index,
                                                                  userData[
                                                                      'residence'],
                                                                  residenceData
                                                                              .docs[
                                                                          index]
                                                                      ['name'],
                                                                  residenceData
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'photoURL'],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                  selected: residenceData
                                                      .docs[index]['flagOut'],
                                                  selectedTileColor: userData[
                                                              'residence'] ==
                                                          residenceData
                                                                  .docs[index]
                                                              ['name']
                                                      ? Colors.yellow
                                                      : Colors.redAccent,
                                                  title: Text(
                                                    '${residenceData.docs[index]['name']}:  Flag ${flagOut ? "Out" : "In"}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.grey[900],
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 19,
                                                    ),
                                                    textScaleFactor: 1,
                                                  ),
                                                  subtitle: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      flagOut
                                                          ? Text(
                                                              'At ' +
                                                                  residenceData
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'flagOutTime'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              textScaleFactor:
                                                                  1,
                                                            )
                                                          : Text(''),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: messageData.docs[
                                                                            count -
                                                                                1]
                                                                        [
                                                                        'read'] ==
                                                                    "false" &&
                                                                messageData.docs[
                                                                            count -
                                                                                1]
                                                                        [
                                                                        'from'] !=
                                                                    userData[
                                                                        "residence"]
                                                            ? Text(
                                                                "New Messages",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                textScaleFactor:
                                                                    1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              )
                                                            : SizedBox.shrink(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      });
                                }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 12),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 22,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
