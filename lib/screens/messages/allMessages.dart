import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shallows/providers/UserResidence.dart';
import 'package:shallows/screens/messages/ChatScreen.dart';
import 'package:shallows/services/UserCollectionSetup.dart';

class AllMessages extends StatefulWidget {
  const AllMessages({Key? key}) : super(key: key);

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  var users = UserCollectionSetup();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //Get Safe Area of Every Device
    var padding = MediaQuery.of(context).padding;
    double newheight = height - padding.top - padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        elevation: 0,
        backgroundColor: Colors.lightBlue[700],
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
        child: FutureBuilder(
            future: usersCollection.doc(auth.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text('Document does not exist');
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      height: newheight * .85,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: users.residences,
                          builder: (context, snapshot) {
                            final data = snapshot.requireData;
                            return ListView.builder(
                                itemCount: data.size,
                                itemBuilder: (context, index) {
                                  return data.docs[index]['name'] !=
                                          userData['residence']
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            tileColor: Colors.teal[200],
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    index,
                                                    userData['residence'],
                                                    data.docs[index]['name'],
                                                    data.docs[index]
                                                        ['photoURL'],
                                                  ),
                                                ),
                                              );
                                            },
                                            leading: Icon(Icons.message,
                                                color: Colors.yellow[200]),
                                            trailing: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.yellow[200]),
                                            selected: false,
                                            selectedTileColor: Colors.yellow,
                                            title: Text(
                                              '${data.docs[index]['name']}',
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                color: Colors.grey[900],
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                });
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 15),
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
                );
              }
              return Text('loading');
            }),
      ),
    );
  }
}
