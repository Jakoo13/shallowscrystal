import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollectionSetup {
  final String uid;
  UserCollectionSetup({this.uid = "0000"});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference residencesCollection =
      FirebaseFirestore.instance.collection('residences');

  Future updateUserData(
    String email,
    String firstName,
    String lastName,
    String residence,
    bool flagOutNotifications,
    bool messageNotifications,
  ) async {
    return await usersCollection.doc(uid).set({
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'residence': residence,
      "flagChangeNotifications": flagOutNotifications,
      "messageNotifications": messageNotifications
    });
  }

  //Get Users Stream
  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }

  // Get Residences Stream
  Stream<QuerySnapshot> get residences {
    print(residencesCollection.snapshots());
    return residencesCollection.snapshots();
  }
}
