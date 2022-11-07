import 'dart:collection';

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

  final Stream<QuerySnapshot> residenceStream =
      FirebaseFirestore.instance.collection('residences').snapshots();

//Returns True if most recent Notification HAS NOT been read
  showNotification() async {
    for (var i = 0; i < residencesList.length; i++) {
      String sortAlphabetically() {
        final sortedSet = SplayTreeSet.from(
          {currentUserSnapshot["residence"], residencesList[i]["name"]},
        );
        return sortedSet.join('');
      }

      QuerySnapshot doc = await FirebaseFirestore.instance
          .collection('messages')
          .doc('${sortAlphabetically()}')
          .collection('chats')
          .orderBy('timeStamp', descending: false)
          .get();
      // Has Messages that haven't been read AND are received NOT sent
      if (doc.docs.length > 0 &&
          doc.docs[doc.docs.length - 1]["read"] == "false" &&
          doc.docs[doc.docs.length - 1]["to"] ==
              currentUserSnapshot["residence"]) {
        hasNotificationFrom.add(doc.docs[doc.docs.length - 1]["from"]);
      }
    }
    print(hasNotificationFrom);
  }

  updateReadStatus(otherResidenceName) async {
    String sortAlphabetically() {
      final sortedSet = SplayTreeSet.from(
        {currentUserSnapshot["residence"], otherResidenceName},
      );
      return sortedSet.join('');
    }

    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('messages')
        .doc('${sortAlphabetically()}')
        .collection('chats')
        .orderBy('timeStamp', descending: false)
        .get();
    final messageData = doc.docs;
    //Getting the last message and that document reference to use to update the field of "read"
    final count = messageData.length;

    final stringSplit = messageData[count - 1].reference.toString().split("/");

    final docRefWithParenthesis = stringSplit[3];
    final docRef =
        docRefWithParenthesis.substring(0, docRefWithParenthesis.length - 1);
    print(docRef);

//ensure the latest message was too you and not from you before updating read status
    if (doc.docs[doc.docs.length - 1]["to"] ==
        currentUserSnapshot["residence"]) {
      await FirebaseFirestore.instance
          .collection('messages/${sortAlphabetically()}/chats')
          .doc(docRef)
          .update({'read': "true"});
    }
  }

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getResidences();
    await getCurrentUser();
    await showNotification();
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
