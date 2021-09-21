import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shallows/screens/lake_page/flag-animation.dart';
import 'package:shallows/services/database.dart';

class Lake extends StatefulWidget {
  static String id = 'lake';
  const Lake({Key? key}) : super(key: key);

  @override
  _LakeState createState() => _LakeState();
}

class _LakeState extends State<Lake> {
  final DatabaseService _database = DatabaseService();

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 230,
                padding: const EdgeInsets.only(bottom: 0),
                child: FlagAnimation(),
                alignment: Alignment.center,
              ),
              SingleChildScrollView(
                child: Container(
                  height: 570,
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
                          return Text('Loading');
                        }
                        final data = snapshot.requireData;
                        return ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  tileColor: Colors.teal[200],
                                  onTap: () {
                                    print(data.docs[index].id);
                                    if (data.docs[index]['flagOut'] == true) {
                                      _database.changeFlagPosition(
                                          false, data.docs[index].id);
                                    } else {
                                      _database.changeFlagPosition(
                                          true, data.docs[index].id);
                                    }
                                  },
                                  trailing: Icon(Icons.flag_rounded),
                                  selected: data.docs[index]['flagOut'],
                                  selectedTileColor: Colors.yellow,
                                  title: Text(
                                    '${data.docs[index]['name']}:  Flag Out - ${data.docs[index]['flagOut'] ? "Yes" : "No"}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    child: Text('Back'),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
