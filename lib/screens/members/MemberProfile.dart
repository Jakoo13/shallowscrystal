import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MemberProfile extends StatefulWidget {
  final int index;
  final String firstName;
  final String lastName;
  final String residence;
  final String? aboutMe;
  final String? personalBest;
  final String photoURL;
  MemberProfile(this.index, this.firstName, this.lastName, this.residence,
      this.aboutMe, this.personalBest, this.photoURL);

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
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
        title: Text('Profile'),
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
                  "${widget.firstName} ${widget.lastName}",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '${widget.residence} Residence',
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey[200]),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'About Me:',
                  style: TextStyle(fontSize: 21, color: Colors.yellow),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blueGrey,
                  ),
                  color: Colors.white70,
                ),
                width: width * .9,
                margin: const EdgeInsets.all(15),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Text(
                  '${widget.aboutMe}',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontFamily: 'RaleWay'),
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Personal Best:',
                  style: TextStyle(fontSize: 21, color: Colors.yellow),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: width * .9,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white70,
                ),
                padding: EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                child: Text(
                  '${widget.personalBest}',
                  style: TextStyle(fontSize: 19, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
