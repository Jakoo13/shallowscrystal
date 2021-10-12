import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionSetup {
  final String uid;
  UserCollectionSetup({this.uid = "0000"});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String firstName, String lastName, String residence, String email) async {
    return await usersCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'residence': residence,
      'email': email,
    });
  }

  Future updateAboutMe(String aboutMe) async {
    return await usersCollection.doc(uid).set({'aboutMe': aboutMe});
  }

  //Get Users Stream
  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }
}
