import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NonUserTile extends StatelessWidget {
  final int index;
  final QueryDocumentSnapshot specificResidentData;

  const NonUserTile({
    Key? key,
    required this.index,
    required this.specificResidentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ? Colors.red[400]
            : Colors.blueGrey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // InkWell(
          //   onTap: () {
          //     print(lakeController
          //         .updateReadStatus(specificResidentData["name"]));
          //   },
          //   child: Container(
          //       width: 100,
          //       height: 50,
          //       color: Colors.black,
          //       child: Center(
          //         child: Text(
          //           "Test Me",
          //           style: TextStyle(
          //             color: Colors.white,
          //           ),
          //         ),
          //       )),
          // ),

          Icon(
            Icons.whatshot_sharp,
            color: Colors.grey[700],
            size: 28,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                specificResidentData['name'],
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey[900],
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
                    fontFamily: "Roboto",
                  );
                }()),
              ),
            ],
          ),

          Icon(
            Icons.whatshot_sharp,
            color: Colors.grey[700],
            size: 28,
          ),

          // //Messages Icons
          // Container(
          //   alignment: Alignment.center,
          //   height: double.infinity,
          //   child: InkWell(
          //     onTap: () {
          //       if (lakeController.currentUserSnapshot["residence"] !=
          //           specificResidentData["name"]) {
          //         lakeController.updateReadStatus(specificResidentData["name"]);
          //       }

          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => ChatScreen(
          //             index,
          //             lakeController.currentUserSnapshot["residence"],
          //             specificResidentData['name'],
          //           ),
          //         ),
          //       );
          //     },
          //     child: Stack(
          //       children: [
          //         Icon(
          //           Icons.message,
          //           color: Colors.blue[600],
          //           size: 32,
          //         ),
          //         Obx(
          //           () => lakeController.hasNotificationFrom
          //                   .contains(specificResidentData["name"])
          //               ? Container(
          //                   height: 20,
          //                   width: 20,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(15),
          //                     color: Colors.red,
          //                   ),
          //                   child: Center(child: Text("1")),
          //                 )
          //               : SizedBox.shrink(),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
