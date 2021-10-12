import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  //const Avatar({Key? key}) : super(key: key);
  final String imagePath;
  final VoidCallback onClick;

  const Avatar({Key? key, required this.imagePath, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClick),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.yellow,
        all: 3,
        child: buildCircle(
          all: 8,
          color: color,
          child: Icon(
            Icons.edit,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          color: color,
          padding: EdgeInsets.all(all),
          child: child,
        ),
      );
}



// return GestureDetector(
//       onTap: onTap,
//       child: Center(
//         child: avatarUrl == null
//             ? CircleAvatar(
//                 radius: 72,
//                 backgroundColor: Colors.grey.shade800,
//                 child: Icon(Icons.photo_camera),
//               )
//             : CircleAvatar(
//                 radius: 72,
//                 backgroundColor: Colors.grey.shade800,
//                 backgroundImage: NetworkImage(avatarUrl!),
//               ),
//       ),
//     );