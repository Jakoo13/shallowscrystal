import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/members/MemberProfile.dart';
import 'package:shallows/screens/members/MembersAnimation.dart';
import 'package:shallows/services/UserCollectionSetup.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  _MembersPageState createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  var users = UserCollectionSetup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
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
        child: Column(
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 0),
              child: MembersAnimation(),
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              height: 400,
              child: StreamBuilder<QuerySnapshot>(
                  stream: users.users,
                  builder: (context, snapshot) {
                    final data = snapshot.requireData;
                    return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              tileColor: Colors.teal[200],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MemberProfile(
                                      index,
                                      data.docs[index]['firstName'],
                                      data.docs[index]['lastName'],
                                      data.docs[index]['residence'],
                                      data.docs[index]['aboutMe'],
                                      data.docs[index]['personalBest'],
                                    ),
                                  ),
                                );
                              },
                              leading: Icon(Icons.flag_sharp),
                              trailing: Icon(Icons.arrow_forward_ios),
                              subtitle: Text(
                                '${data.docs[index]['residence']} Residence',
                                textAlign: TextAlign.center,
                              ),
                              selected: false,
                              selectedTileColor: Colors.yellow,
                              title: Text(
                                '${data.docs[index]['firstName']} ${data.docs[index]['lastName']}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
