import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/lake/FlagAnimation.dart';
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

    return FutureBuilder<DocumentSnapshot>(
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
            return Scaffold(
              appBar: AppBar(
                title: Text('Lake'),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 190,
                        padding: const EdgeInsets.only(bottom: 0),
                        child: FlagAnimation(),
                        alignment: Alignment.center,
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: newheight * .65,
                          padding: const EdgeInsets.only(top: 20),
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
                                final data = snapshot.requireData;

                                return ListView.builder(
                                    itemCount: data.size,
                                    itemBuilder: (context, index) {
                                      var flagOut = data.docs[index]['flagOut'];
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          enabled: userData['residence'] ==
                                                  data.docs[index]['name']
                                              ? true
                                              : false,
                                          tileColor: userData['residence'] ==
                                                  data.docs[index]['name']
                                              ? Colors.white
                                              : Colors.teal[200],
                                          onTap: () {
                                            residences
                                                .doc(data.docs[index].id)
                                                .update({
                                                  'flagOutTime': dateFormatted,
                                                })
                                                .then((value) =>
                                                    print('Profile Updated'))
                                                .catchError(
                                                    (error) => print(error));
                                            print(data.docs[index].id);
                                            if (flagOut == true) {
                                              _database.changeFlagPosition(
                                                  false, data.docs[index].id);
                                            } else {
                                              _database.changeFlagPosition(
                                                  true, data.docs[index].id);
                                            }
                                          },
                                          leading: flagOut
                                              ? Icon(Icons.flag_sharp,
                                                  color: Colors.black)
                                              : Icon(Icons.whatshot_sharp),
                                          trailing: flagOut
                                              ? Icon(Icons.flag_sharp,
                                                  color: Colors.black)
                                              : Icon(Icons.whatshot_sharp),
                                          selected: data.docs[index]['flagOut'],
                                          selectedTileColor:
                                              userData['residence'] ==
                                                      data.docs[index]['name']
                                                  ? Colors.yellow
                                                  : Colors.redAccent,
                                          title: Text(
                                            '${data.docs[index]['name']}:  Flag ${flagOut ? "Out" : "In"}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey[900],
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              flagOut
                                                  ? Text(
                                                      'At ' +
                                                          data.docs[index]
                                                              ['flagOutTime'],
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
                                                  : Text(''),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Text('loading');
        });
  }
}
