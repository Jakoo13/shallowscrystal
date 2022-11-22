import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetResidencesController extends GetxController {
  List residencesList = [].obs;
  List<String> residencesListString = [];

  CollectionReference residences =
      FirebaseFirestore.instance.collection('residences');

  @override
  Future<void> onInit() async {
    super.onInit();
    await getResidences();
  }

  getResidences() async {
    var res = await residences.get();
    residencesList = res.docs;
    res.docs.forEach((element) {
      residencesListString.add(element["name"]);
    });
  }
}
