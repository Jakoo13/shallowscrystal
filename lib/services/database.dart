import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference residencesCollection =
      FirebaseFirestore.instance.collection('residences');

  Stream<QuerySnapshot> get residenceSnapshot {
    return residencesCollection.snapshots();
  }

  Future getCurrentResidence() async {
    CollectionReference residences =
        FirebaseFirestore.instance.collection('residences');
    residences.get().then((QuerySnapshot querySnapshot) {
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

  Future<void> userSetup(String residence, String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid;
    users.add({
      'uid': uid,
      'email': email,
      'residence': residence,
    });
    return;
  }
}


/// can also do: 
///final Stream<QuerySnapshot> residenceSnapshot = FirebaseFirestore.instance.collection('residences').snapshots();
/// same thing