import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResidenceProfile extends StatefulWidget {
  final int index;
  final String name;
  final String? about;

  final String photoURL;
  ResidenceProfile(this.index, this.name, this.about, this.photoURL);

  @override
  State<ResidenceProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<ResidenceProfile> {
  final double coverHeight = 200;

  final double profileHeight = 144;

  static Future<dynamic> loadImage(BuildContext context, String path) async {
    String image =
        await FirebaseStorage.instance.ref().child(path).getDownloadURL();

    return image.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          textScaleFactor: 1,
          style: TextStyle(fontSize: 23),
        ),
        elevation: 0,
        backgroundColor: Colors.lightBlue[700],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          buildContent(),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: buildProfileImage(),
          ),
        ],
      ),
    );
  }

  Widget buildProfileImage() => Container(
        width: 200,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.yellow,
            width: 4.0,
          ),
        ),
        child: FutureBuilder(
          future: loadImage(context, widget.photoURL),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey,
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(snapshot.data.toString()),
                  ),
                ),
              );
            }

            return Container();
          },
        ),
      );

  // Bottom Content
  Widget buildContent() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      //height: height,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 58, 123, 213),
            Color.fromARGB(255, 58, 96, 115),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 220),
                child: Text(
                  "${widget.name} Residence",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40, bottom: 18),
                child: Text(
                  'About:',
                  style: TextStyle(fontSize: 25, color: Colors.yellow),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blueGrey,
                  ),
                  color: Colors.white70,
                ),
                height: height * .27,
                width: width * .87,
                margin: const EdgeInsets.only(
                    top: 15, bottom: 15, left: 15, right: 15),
                padding:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                child: Text(
                  '${widget.about}',
                  style: GoogleFonts.mukta(
                    fontSize: 19,
                    color: Colors.black,
                  ),
                  maxLines: 7,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       padding: EdgeInsets.only(top: 20),
          //       child: Text(
          //         'Contact:',
          //         style: TextStyle(fontSize: 21, color: Colors.yellow),
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     Container(
          //       width: width * .9,
          //       decoration: BoxDecoration(
          //         border: Border.all(color: Colors.blueGrey),
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.white70,
          //       ),
          //       padding: EdgeInsets.all(10),
          //       margin: const EdgeInsets.all(15),
          //       child: Text(
          //         '${widget.contact}',
          //         style: TextStyle(fontSize: 19, color: Colors.black87),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
