import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';
import 'dart:async';

import 'MessageModel.dart';

class ChatController extends GetxController {
  final lakeController = Get.find<LakeScreenController>();
  final RxList<List<Message>> messages = RxList<List<Message>>();
  final RxList messages1 = RxList();
  final RxBool shownTile = false.obs;

  final messagesFromAndTo = RxList<String>();

  RxList collectionElements = [].obs;

  @override
  void onInit() async {
    messages.bindStream(getData());
    // print(mergedStream);
    super.onInit();
  }

  Stream<List<List<Message>>> getData() {
    List<Stream<List<Message>>> listStreams = [];
    for (var i = 0; i < lakeController.residencesList.length; i++) {
      Stream<QuerySnapshot?> stream = FirebaseFirestore.instance
          .collection('messages')
          .doc(lakeController.currentUserSnapshot["residence"])
          .collection(lakeController.residencesList[i]["name"].toString())
          .snapshots();

      Stream<List<Message>> mappedData = stream.map((snapshot) => snapshot!.docs
          .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
          .toList());

      listStreams.add(mappedData);
    }

    return StreamZip([...listStreams]);
  }

  void updateData() {
    print("Calling::");
    messages.bindStream(getData());
  }
}
