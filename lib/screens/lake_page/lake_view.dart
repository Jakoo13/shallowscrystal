import 'dart:math';

import 'package:flutter/material.dart';

class LakeView extends StatefulWidget {
  const LakeView({Key? key}) : super(key: key);

  @override
  _LakeViewState createState() => _LakeViewState();
}

class _LakeViewState extends State<LakeView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        height: 300,
        color: Colors.white,
        child: CustomPaint(
          painter: LakePainter(),
        ));
  }
}

class LakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = Colors.blue;

    canvas.drawCircle(center, radius - 40, fillBrush);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
