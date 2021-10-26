import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  //Residences Collection
  final residencesCollection =
      FirebaseFirestore.instance.collection('residences').orderBy('position');

  Stream<QuerySnapshot> get residenceSnapshot {
    return residencesCollection.snapshots();
  }

  //Users Collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> get usersSnapshot {
    return usersCollection.snapshots();
  }

  // Get all residences
  Future getCurrentResidences() async {
    residencesCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc['name']);
      });
    });
  }

  // Get residence of user Signed In
  getCurrentResident() async {
    DocumentReference documentReference =
        usersCollection.doc(auth.currentUser!.uid);
    String residence;
    await documentReference.get().then((snapshot) {
      residence = snapshot['residence'].toString();

      return residence;
    });
    return 'residence is null';
  }

  //Change Flag from In to Out or vice versa
  Future<void> changeFlagPosition(bool _flagPosition, String id) async {
    await firestore
        .collection("residences")
        .doc(id)
        .update({"flagOut": _flagPosition});
  }
}
