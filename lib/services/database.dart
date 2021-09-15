import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference residencesCollection =
      FirebaseFirestore.instance.collection('residences');

  Stream<QuerySnapshot> get residenceSnapshot {
    return residencesCollection.snapshots();
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