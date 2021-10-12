import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Residences Collection
  final CollectionReference residencesCollection =
      FirebaseFirestore.instance.collection('residences');

  Stream<QuerySnapshot> get residenceSnapshot {
    return residencesCollection.snapshots();
  }

  //Users Collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get usersSnapshot {
    return usersCollection.snapshots();
  }

  Future getCurrentResidence() async {
    residencesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['name']);
      });
    });
  }

  Future<void> changeFlagPosition(bool _flagPosition, String id) async {
    await firestore
        .collection("residences")
        .doc(id)
        .update({"flagOut": _flagPosition});
  }
}


/// can also do: 
///final Stream<QuerySnapshot> residenceSnapshot = FirebaseFirestore.instance.collection('residences').snapshots();
/// same thing