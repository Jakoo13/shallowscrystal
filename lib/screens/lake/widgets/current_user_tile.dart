import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ShallowsCrystal/screens/lake/lake_screen_controller.dart';
import 'package:intl/intl.dart';

class CurrentUserTile extends StatelessWidget {
  final int index;
  final QueryDocumentSnapshot specificResidentData;
  const CurrentUserTile({
    Key? key,
    required this.index,
    required this.specificResidentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    final DateFormat formatter = DateFormat('jm');
    final String dateFormatted = formatter.format(now);
    final lakeController = Get.find<LakeScreenController>();
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
                  title: Text(
                    "Are you sure?",
                    textScaleFactor: 1,
                    style: TextStyle(fontSize: 20),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text("Yes",
                          style: TextStyle(fontSize: 20), textScaleFactor: 1),
                      onPressed: () {
                        lakeController.residences
                            .doc(specificResidentData["name"])
                            .update({
                          'flagOutTime': dateFormatted,
                        }).catchError((error) => print(error));

                        if (specificResidentData["flagOut"] == true) {
                          lakeController.changeFlagPosition(
                              false, specificResidentData["name"]);
                        } else {
                          lakeController.changeFlagPosition(
                              true, specificResidentData["name"]);
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text("No",
                          style: TextStyle(fontSize: 20), textScaleFactor: 1),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      },
      child: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 8,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: specificResidentData["flagOut"]
              ? Colors.red[600]
              : Color.fromARGB(255, 255, 235, 59),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.whatshot_sharp,
              color: specificResidentData["flagOut"]
                  ? Colors.black
                  : Colors.grey[700],
              size: 28,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  specificResidentData['name'],
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w700,
                  ),
                ),
                //Conditionally Display Flag Out Time IF flag is out
                Text(
                  (() {
                    if (specificResidentData["flagOut"]) {
                      return "Flag Out: ${specificResidentData["flagOutTime"]}";
                    }
                    return "";
                  }()),
                  style: (() {
                    return TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    );
                  }()),
                ),
              ],
            ),
            Icon(
              Icons.whatshot_sharp,
              color: specificResidentData["flagOut"]
                  ? Colors.black
                  : Colors.grey[700],
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
