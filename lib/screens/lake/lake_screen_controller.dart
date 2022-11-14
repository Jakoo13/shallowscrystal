import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LakeScreenController extends GetxController {
  List residencesList = [].obs;
  late final DocumentSnapshot currentUserSnapshot;

  List hasNotificationFrom = [].obs;

  CollectionReference residences =
      FirebaseFirestore.instance.collection('residences');

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final Stream<QuerySnapshot> residenceStream = FirebaseFirestore.instance
      .collection('residences')
      .orderBy("position")
      .snapshots();

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getResidences();
    await getCurrentUser();
  }

  getCurrentUser() async {
    var thisUser = await users.doc(currentUser!.uid).get();

    return currentUserSnapshot = thisUser;
  }

  getResidences() async {
    var res = await residences.get();
    residencesList = res.docs;
  }

  bool flagIsOut(index) {
    if (residencesList[index]['flagOut']) {
      return true;
    } else {
      return false;
    }
  }

  //Change Flag from In to Out or vice versa
  Future<void> changeFlagPosition(bool _flagPosition, String id) async {
    await FirebaseFirestore.instance
        .collection("residences")
        .doc(id)
        .update({"flagOut": _flagPosition});
  }
}
