import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shallows/screens/lake/lake_screen_controller.dart';

import 'MessageModel.dart';

class ChatController extends GetxController {
  final lakeController = Get.find<LakeScreenController>();
  final RxList<QuerySnapshot> messages = RxList<QuerySnapshot>();
  final RxBool shownTile = false.obs;

  final messagesFromAndTo = RxList<String>();

  RxList collectionElements = [].obs;

  @override
  onInit() async {
    messages.bindStream(mergedStream);
    getData();
    super.onInit();
  }

  List<Stream> streamList = [];
  var mergedStream;

  getData() {
    for (var i = 0; i < lakeController.residencesList.length; i++) {
      Stream<QuerySnapshot?> stream = FirebaseFirestore.instance
          .collection('messages')
          .doc(lakeController.currentUserSnapshot["residence"])
          .collection(lakeController.residencesList[i]["name"].toString())
          .snapshots();

      streamList.add(stream);
      print(streamList);
    }
    return mergedStream = MergeStream(streamList);
  }
  // Stream<List<Message>> streamMessages() {
  //   for (var i = 0; i < lakeController.residencesList.length; i++) {
  // Stream<QuerySnapshot?> stream = FirebaseFirestore.instance
  //     .collection('messages')
  //     .doc(lakeController.currentUserSnapshot["residence"])
  //     .collection(lakeController.residencesList[i]["name"].toString())
  //     .snapshots();

  //     var data = stream.map((querySnapshot) => querySnapshot!.docs
  //         .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList());
  //     print(lakeController.residencesList[i]["name"]);
  //     print(data);
  //   }
  //   throw "error";
  // }
}
