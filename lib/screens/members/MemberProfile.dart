import 'package:flutter/material.dart';
import 'package:shallows/screens/profile/Avatar.dart';

class MemberProfile extends StatefulWidget {
  final int index;
  final String firstName;
  final String lastName;
  final String residence;
  final String aboutMe;
  final String personalBest;
  MemberProfile(this.index, this.firstName, this.lastName, this.residence,
      this.aboutMe, this.personalBest);

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  final double coverHeight = 200;

  final double profileHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.lightBlue[700],
      ),
      body: Stack(
        children: [
          buildContent(),
          buildTop(),
        ],
      ),
    );
  }

  Widget buildTop() {
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        buildCoverImage(),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/LakesideEstates.jpg'),
                ),
              ),
              height: coverHeight,
            ),
            Container(
              height: coverHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            )
          ],
        ),
      );

  Widget buildProfileImage() => Container(
        width: 200,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
            color: Colors.yellow,
            width: 4.0,
          ),
        ),
        child: Avatar(
            imagePath:
                'https://scontent.fphx1-1.fna.fbcdn.net/v/t1.6435-9/135292659_10159211270053960_6003474687665634357_n.jpg?_nc_cat=106&ccb=1-5&_nc_sid=09cbfe&_nc_ohc=LLixfywgwQQAX_OvrDU&_nc_ht=scontent.fphx1-1.fna&oh=9cba6c2ed46e003669c1934f3bd60c32&oe=6187BD37',
            onClick: () => {}),
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
                padding: EdgeInsets.only(top: 285),
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
                    color: Colors.yellow,
                  ),
                  color: Colors.yellowAccent.withOpacity(.2),
                  gradient: new LinearGradient(
                    colors: [Colors.yellow, Colors.cyan],
                  ),
                ),
                width: width * .9,
                margin: const EdgeInsets.all(15),
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                child: Text(
                  '${widget.aboutMe}',
                  style: TextStyle(
                      fontSize: 18, color: Colors.white, fontFamily: 'RaleWay'),
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
                  border: Border.all(color: Colors.yellow),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellowAccent.withOpacity(.2),
                  gradient: new LinearGradient(
                    colors: [Colors.yellow, Colors.cyan],
                  ),
                ),
                padding: EdgeInsets.all(10),
                margin: const EdgeInsets.all(15),
                child: Text(
                  '${widget.personalBest}',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
