import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/residences/ResidenceProfile.dart';
import 'package:shallows/screens/residences/MembersAnimation.dart';
import 'package:shallows/services/UserCollectionSetup.dart';

class ResidencesPage extends StatefulWidget {
  const ResidencesPage({Key? key}) : super(key: key);

  @override
  _ResidencesPageState createState() => _ResidencesPageState();
}

class _ResidencesPageState extends State<ResidencesPage> {
  var users = UserCollectionSetup();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Residences'),
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
                  stream: users.residences,
                  builder: (context, snapshot) {
                    final data = snapshot.requireData;
                    return ListView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              tileColor: Colors.teal[200],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResidenceProfile(
                                      index,
                                      data.docs[index]['name'],
                                      data.docs[index]['about'],
                                      data.docs[index]['contact'],
                                      data.docs[index]['photoURL'],
                                    ),
                                  ),
                                );
                              },
                              leading: Icon(Icons.flag_sharp),
                              trailing: Icon(Icons.arrow_forward_ios),
                              selected: false,
                              selectedTileColor: Colors.yellow,
                              title: Text(
                                '${data.docs[index]['name']}',
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
        ),
      ),
    );
  }
}
