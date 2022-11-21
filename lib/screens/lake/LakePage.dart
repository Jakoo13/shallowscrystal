import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShallowsCrystal/screens/messages/AllMessages.dart';
import 'package:ShallowsCrystal/screens/messages/chat_controller.dart';
import 'widgets/current_user_tile.dart';
import 'lake_screen_controller.dart';
import 'widgets/non_user_tile.dart';

class LakePage extends StatefulWidget {
  static String id = 'LakePage';
  const LakePage({Key? key}) : super(key: key);

  @override
  _LakePageState createState() => _LakePageState();
}

class _LakePageState extends State<LakePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    bool unreadMessages = false;
    final lakeController = Get.find<LakeScreenController>();
    var chatController = Get.put(ChatController());
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: StreamBuilder<QuerySnapshot>(
          stream: chatController.mostRecentMessagesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            //See if any unread messages
            var messageData = snapshot.data!.docs;
            for (var i = 0; i < messageData.length; i++) {
              if (messageData[i]["residenceFrom"] !=
                      lakeController.currentUserSnapshot["residence"] &&
                  messageData[i]["read"] == false) {
                unreadMessages = true;
              }
            }
            //Come Back
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 41, 47, 63),
                title: Text(
                  "Lake Rotation",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 27,
                    fontFamily: "Roboto",
                    letterSpacing: 2,
                  ),
                ),
                elevation: 2,
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Get.to(() => AllMessages());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 18.0),
                      child: Stack(
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.white70,
                            size: 30,
                          ),
                          unreadMessages
                              ? Container(
                                  height: 13,
                                  width: 13,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.red,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 41, 47, 63),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: lakeController.residenceStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 40,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot data = snapshot.data!.docs[index];
                        return showResidenceTile(context, index, data);
                      },
                    );
                  },
                ),
              ),
            );
          }),
    );
  }
}

Widget showResidenceTile(context, index, data) {
  final lakeController = Get.find<LakeScreenController>();
  if (data["name"] == lakeController.currentUserSnapshot["residence"]) {
    return CurrentUserTile(index: index, specificResidentData: data);
  } else {
    return NonUserTile(
      index: index,
      specificResidentData: data,
    );
  }
}
      // FutureBuilder<DocumentSnapshot>(
      //     future: users.doc(auth.currentUser!.uid).get(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //       if (snapshot.hasError) {
      //         return Text('Something went wrong');
      //       }
      //       if (snapshot.hasData && !snapshot.data!.exists) {
      //         return Text('Document does not exist');
      //       }
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return CircularProgressIndicator();
      //       }
      //       if (snapshot.connectionState == ConnectionState.done) {
      //         Map<String, dynamic> userData =
      //             snapshot.data!.data() as Map<String, dynamic>;
      //         return Scaffold(
      //           appBar: AppBar(
      //             title: Text('Lake Queue'),
      //             elevation: 0,
      //             backgroundColor: Colors.lightBlue[700],
      //           ),
      //           body: Container(
      //             decoration: new BoxDecoration(
      //               gradient: new LinearGradient(
      //                 begin: Alignment.topCenter,
      //                 end: Alignment.bottomCenter,
      //                 colors: [
      //                   Color.fromARGB(255, 58, 123, 213),
      //                   Color.fromARGB(255, 58, 96, 115),
      //                 ],
      //               ),
      //             ),
      //             child: Padding(
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 18.0, vertical: 10),
      //               child: Column(
      //                 children: [
      //                   SingleChildScrollView(
      //                     child: Container(
      //                       height: newheight * .84,
      //                       padding: const EdgeInsets.only(top: 10),
      //                       child: 
      // StreamBuilder<QuerySnapshot>(
      //                         stream: _database.residenceSnapshot,
      //                         builder: (
      //                           BuildContext context,
      //                           AsyncSnapshot<QuerySnapshot> snapshot,
      //                         ) {
      //                           if (snapshot.hasError) {
      //                             return Text('Something Went Wrong');
      //                           }
      //                           if (snapshot.connectionState ==
      //                               ConnectionState.waiting) {
      //                             return CircularProgressIndicator();
      //                           }
      //                           final residenceData = snapshot.requireData;

      //                           return ListView.builder(
      //                               itemCount: residenceData.size,
      //                               itemBuilder: (context, index) {
      //                                 var flagOut =
      //                                     residenceData.docs[index]['flagOut'];
      //                                 String sortAlphabetically() {
      //                                   final sortedSet = SplayTreeSet.from(
      //                                     {
      //                                       "${userData['residence']}",
      //                                       "${residenceData.docs[index]['name']}"
      //                                     },
      //                                   );

      //                                   return sortedSet.join('');
      //                                 }

      //                                 return 
      // StreamBuilder(
      //                                     stream: fireStore
      //                                         .collection('messages')
      //                                         .doc('${sortAlphabetically()}')
      //                                         .collection('chats')
      //                                         .orderBy('timeStamp',
      //                                             descending: false)
      //                                         .snapshots(),
      //                                     builder: (
      //                                       context,
      //                                       AsyncSnapshot<QuerySnapshot>
      //                                           chatSnapshot,
      //                                     ) {
      //                                       if (chatSnapshot.hasError) {
      //                                         return Text(
      //                                             'Something Went Wrong');
      //                                       }
      //                                       if (chatSnapshot.connectionState ==
      //                                           ConnectionState.waiting) {
      //                                         return CircularProgressIndicator();
      //                                       }

      //                                       if (chatSnapshot.hasData) {
      //                                         if (chatSnapshot
      //                                                 .data!.docs.length ==
      //                                             0) {
      //                                           return Card(
      //                                             shape: RoundedRectangleBorder(
      //                                               borderRadius:
      //                                                   BorderRadius.circular(
      //                                                       25),
      //                                             ),
      //                                             child: ListTile(
      //                                               shape:
      //                                                   RoundedRectangleBorder(
      //                                                 borderRadius:
      //                                                     BorderRadius.circular(
      //                                                         25),
      //                                               ),
      //                                               enabled: userData[
      //                                                           'residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? true
      //                                                   : false,
      //                                               tileColor: userData[
      //                                                           'residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Colors.white
      //                                                   : Colors.teal[200],
      //                                               onTap: () {
      //                                                 showDialog(
      //                                                     context: context,
      //                                                     builder: (_) =>
      //                                                         CupertinoAlertDialog(
      //                                                           title: Text(
      //                                                             "Are you sure?",
      //                                                             textScaleFactor:
      //                                                                 1,
      //                                                             style: TextStyle(
      //                                                                 fontSize:
      //                                                                     20),
      //                                                           ),
      //                                                           actions: [
      //                                                             CupertinoDialogAction(
      //                                                               child: Text(
      //                                                                   "Yes",
      //                                                                   style: TextStyle(
      //                                                                       fontSize:
      //                                                                           20),
      //                                                                   textScaleFactor:
      //                                                                       1),
      //                                                               onPressed:
      //                                                                   () {
      //                                                                 residences
      //                                                                     .doc(residenceData
      //                                                                         .docs[
      //                                                                             index]
      //                                                                         .id)
      //                                                                     .update({
      //                                                                       'flagOutTime':
      //                                                                           dateFormatted,
      //                                                                     })
      //                                                                     .then((value) => print(
      //                                                                         'Profile Updated'))
      //                                                                     .catchError((error) =>
      //                                                                         print(error));
      //                                                                 print(residenceData
      //                                                                     .docs[
      //                                                                         index]
      //                                                                     .id);
      //                                                                 if (flagOut ==
      //                                                                     true) {
      //                                                                   _database.changeFlagPosition(
      //                                                                       false,
      //                                                                       residenceData.docs[index].id);
      //                                                                 } else {
      //                                                                   _database.changeFlagPosition(
      //                                                                       true,
      //                                                                       residenceData.docs[index].id);
      //                                                                 }
      //                                                                 Navigator.of(
      //                                                                         context)
      //                                                                     .pop();
      //                                                               },
      //                                                             ),
      //                                                             CupertinoDialogAction(
      //                                                               child: Text(
      //                                                                   "No",
      //                                                                   style: TextStyle(
      //                                                                       fontSize:
      //                                                                           20),
      //                                                                   textScaleFactor:
      //                                                                       1),
      //                                                               onPressed:
      //                                                                   () {
      //                                                                 Navigator.of(
      //                                                                         context)
      //                                                                     .pop();
      //                                                               },
      //                                                             )
      //                                                           ],
      //                                                         ));
      //                                               },
      //                                               leading: flagOut
      //                                                   ? Icon(
      //                                                       Icons.flag_outlined,
      //                                                       color: Colors.black)
      //                                                   : Icon(Icons
      //                                                       .whatshot_sharp),
      //                                               trailing: userData[
      //                                                           'residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Icon(Icons
      //                                                       .whatshot_sharp)
      //                                                   : IconButton(
      //                                                       icon: new Icon(
      //                                                         Icons.message,
      //                                                         color:
      //                                                             Colors.blue,
      //                                                       ),
      //                                                       onPressed: () {
      //                                                         Navigator.push(
      //                                                           context,
      //                                                           MaterialPageRoute(
      //                                                             builder:
      //                                                                 (context) =>
      //                                                                     ChatScreen(
      //                                                               index,
      //                                                               userData[
      //                                                                   'residence'],
      //                                                               residenceData
      //                                                                       .docs[index]
      //                                                                   [
      //                                                                   'name'],
      //                                                               residenceData
      //                                                                       .docs[index]
      //                                                                   [
      //                                                                   'photoURL'],
      //                                                             ),
      //                                                           ),
      //                                                         );
      //                                                       },
      //                                                     ),
      //                                               selected: residenceData
      //                                                   .docs[index]['flagOut'],
      //                                               selectedTileColor: userData[
      //                                                           'residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Colors.yellow
      //                                                   : Colors.redAccent,
      //                                               title: Text(
      //                                                 '${residenceData.docs[index]['name']}:  Flag ${flagOut ? "Out" : "In"}',
      //                                                 textAlign:
      //                                                     TextAlign.center,
      //                                                 style: TextStyle(
      //                                                   color: Colors.grey[900],
      //                                                   fontWeight:
      //                                                       FontWeight.w700,
      //                                                   fontSize: 19,
      //                                                 ),
      //                                                 textScaleFactor: 1,
      //                                               ),
      //                                               subtitle: Column(
      //                                                 crossAxisAlignment:
      //                                                     CrossAxisAlignment
      //                                                         .start,
      //                                                 children: [
      //                                                   flagOut
      //                                                       ? Text(
      //                                                           'At ' +
      //                                                               residenceData
      //                                                                       .docs[index]
      //                                                                   [
      //                                                                   'flagOutTime'],
      //                                                           style: TextStyle(
      //                                                               color: Colors
      //                                                                   .black),
      //                                                           textScaleFactor:
      //                                                               1,
      //                                                         )
      //                                                       : Text(''),
      //                                                 ],
      //                                               ),
      //                                             ),
      //                                           );
      //                                         }
      //                                       }
      //                                       final messageData =
      //                                           chatSnapshot.data;
      //                                       //Getting the last message and that document reference to use to update the field of "read"
      //                                       final count =
      //                                           messageData!.docs.length;

      //                                       final stringSplit = messageData
      //                                           .docs[count - 1].reference
      //                                           .toString()
      //                                           .split("/");
      //                                       final docRefWithParenthesis =
      //                                           stringSplit[3];
      //                                       final docRef =
      //                                           docRefWithParenthesis.substring(
      //                                               0,
      //                                               docRefWithParenthesis
      //                                                       .length -
      //                                                   1);
      //                                       print(messageData.docs[count - 1]
      //                                           ['read']);
      //                                       return Card(
      //                                         shape: RoundedRectangleBorder(
      //                                           borderRadius:
      //                                               BorderRadius.circular(25),
      //                                         ),
      //                                         child: ListTile(
      //                                           shape: RoundedRectangleBorder(
      //                                             borderRadius:
      //                                                 BorderRadius.circular(25),
      //                                           ),
      //                                           enabled:
      //                                               userData['residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? true
      //                                                   : false,
      //                                           tileColor:
      //                                               userData['residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Colors.white
      //                                                   : Colors.teal[200],
      //                                           onTap: () {
      //                                             showDialog(
      //                                                 context: context,
      //                                                 builder: (_) =>
      //                                                     CupertinoAlertDialog(
      //                                                       title: Text(
      //                                                         "Change Flag Position?",
      //                                                         textScaleFactor:
      //                                                             1,
      //                                                         style: TextStyle(
      //                                                             fontSize: 20),
      //                                                       ),
      //                                                       actions: [
      //                                                         CupertinoDialogAction(
      //                                                           child: Text(
      //                                                               "Yes",
      //                                                               style: TextStyle(
      //                                                                   fontSize:
      //                                                                       20),
      //                                                               textScaleFactor:
      //                                                                   1),
      //                                                           onPressed: () {
      //                                                             residences
      //                                                                 .doc(residenceData
      //                                                                     .docs[
      //                                                                         index]
      //                                                                     .id)
      //                                                                 .update({
      //                                                                   'flagOutTime':
      //                                                                       dateFormatted,
      //                                                                 })
      //                                                                 .then((value) =>
      //                                                                     print(
      //                                                                         'Profile Updated'))
      //                                                                 .catchError(
      //                                                                     (error) =>
      //                                                                         print(error));
      //                                                             print(residenceData
      //                                                                 .docs[
      //                                                                     index]
      //                                                                 .id);
      //                                                             if (flagOut ==
      //                                                                 true) {
      //                                                               _database.changeFlagPosition(
      //                                                                   false,
      //                                                                   residenceData
      //                                                                       .docs[index]
      //                                                                       .id);
      //                                                             } else {
      //                                                               _database.changeFlagPosition(
      //                                                                   true,
      //                                                                   residenceData
      //                                                                       .docs[index]
      //                                                                       .id);
      //                                                             }
      //                                                             Navigator.of(
      //                                                                     context)
      //                                                                 .pop();
      //                                                           },
      //                                                         ),
      //                                                         CupertinoDialogAction(
      //                                                           child: Text(
      //                                                               "No",
      //                                                               style: TextStyle(
      //                                                                   fontSize:
      //                                                                       20),
      //                                                               textScaleFactor:
      //                                                                   1),
      //                                                           onPressed: () {
      //                                                             Navigator.of(
      //                                                                     context)
      //                                                                 .pop();
      //                                                           },
      //                                                         )
      //                                                       ],
      //                                                     ));
      //                                           },
      //                                            
      //                                           leading: flagOut
      //                                               ? Icon(Icons.flag_rounded,
      //                                                   color: Colors.black)
      //                                               : Icon(
      //                                                   Icons.whatshot_sharp),
      //                                           trailing: userData[
      //                                                       'residence'] ==
      //                                                   residenceData
      //                                                       .docs[index]['name']
      //                                               ? Icon(Icons.whatshot_sharp)
      //                                               : IconButton(
      //                                                   icon: new Icon(
      //                                                     Icons.message,
      //                                                     color: Colors.blue,
      //                                                   ),
      //                                                   onPressed: () async {
      //                                                     await FirebaseFirestore
      //                                                         .instance
      //                                                         .collection(
      //                                                             'messages/${sortAlphabetically()}/chats')
      //                                                         .doc(docRef)
      //                                                         .update({
      //                                                       'read': "true"
      //                                                     });
      //                                                     Navigator.push(
      //                                                       context,
      //                                                       MaterialPageRoute(
      //                                                         builder:
      //                                                             (context) =>
      //                                                                 ChatScreen(
      //                                                           index,
      //                                                           userData[
      //                                                               'residence'],
      //                                                           residenceData
      //                                                                       .docs[
      //                                                                   index]
      //                                                               ['name'],
      //                                                           residenceData
      //                                                                       .docs[
      //                                                                   index][
      //                                                               'photoURL'],
      //                                                         ),
      //                                                       ),
      //                                                     );
      //                                                   },
      //                                                 ),
      //                                           selected: residenceData
      //                                               .docs[index]['flagOut'],
      //                                           selectedTileColor:
      //                                               userData['residence'] ==
      //                                                       residenceData
      //                                                               .docs[index]
      //                                                           ['name']
      //                                                   ? Colors.yellow
      //                                                   : Colors.redAccent,
      //                                           title: Text(
      //                                             '${residenceData.docs[index]['name']}:  Flag ${flagOut ? "Out" : "In"}',
      //                                             textAlign: TextAlign.center,
      //                                             style: TextStyle(
      //                                               color: Colors.grey[900],
      //                                               fontWeight: FontWeight.w700,
      //                                               fontSize: 19,
      //                                             ),
      //                                             textScaleFactor: 1,
      //                                           ),
      //                                           subtitle: Row(
      //                                             crossAxisAlignment:
      //                                                 CrossAxisAlignment.start,
      //                                             mainAxisAlignment:
      //                                                 MainAxisAlignment.start,
      //                                             children: [
      //                                               flagOut
      //                                                   ? Text(
      //                                                       'At ' +
      //                                                           residenceData
      //                                                                       .docs[
      //                                                                   index][
      //                                                               'flagOutTime'],
      //                                                       style: TextStyle(
      //                                                           color: Colors
      //                                                               .black),
      //                                                       textScaleFactor: 1,
      //                                                     )
      //                                                   : Text(''),
      //                                               Container(
      //                                                 padding:
      //                                                     const EdgeInsets.only(
      //                                                         left: 15),
      //                                                 child: messageData.docs[
      //                                                                     count -
      //                                                                         1]
      //                                                                 [
      //                                                                 'read'] ==
      //                                                             "false" &&
      //                                                         messageData.docs[
      //                                                                     count -
      //                                                                         1]
      //                                                                 [
      //                                                                 'from'] !=
      //                                                             userData[
      //                                                                 "residence"]
      //                                                     ? Text(
      //                                                         "New Messages",
      //                                                         style: TextStyle(
      //                                                           color: Colors
      //                                                               .white,
      //                                                         ),
      //                                                         textScaleFactor:
      //                                                             1,
      //                                                         textAlign:
      //                                                             TextAlign.end,
      //                                                       )
      //                                                     : SizedBox.shrink(),
      //                                               )
      //                                             ],
      //                                           ),
      //                                         ),
      //                                       );
      //                                     });
      //                               });
      //                         },
      //                       ),
      //                     ),
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                         padding: const EdgeInsets.only(top: 12),
      //                         alignment: Alignment.center,
      //                         child: Icon(
      //                           Icons.arrow_downward,
      //                           color: Colors.white,
      //                           size: 22,
      //                         ),
      //                       )
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //         );
      //       }
      //       return Center(
      //           child: CircularProgressIndicator(
      //         color: Colors.yellow,
      //       ));
      //     }),
 
