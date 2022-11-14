import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';

class ChatController extends GetxController {
  final lakeController = Get.find<LakeScreenController>();

  @override
  void onInit() async {
    super.onInit();
  }

  // Get Residences Stream
  Stream<QuerySnapshot> get mostRecentMessagesStream {
    return FirebaseFirestore.instance
        .collection("mostRecentMessages")
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("fromAndTo")
        .orderBy("timeStamp", descending: true)
        .snapshots();
  }

  //Change last message to read when users clicks into it
  Future<void> updateReadStatus(otherResidence) async {
    await FirebaseFirestore.instance
        .collection("mostRecentMessages")
        .doc(lakeController.currentUserSnapshot["residence"])
        .collection("fromAndTo")
        .doc(otherResidence)
        .update({"read": true});
  }
}
