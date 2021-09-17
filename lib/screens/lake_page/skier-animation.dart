import 'package:flutter/material.dart';

class SkierAnimation extends StatefulWidget {
  const SkierAnimation({Key? key}) : super(key: key);

  @override
  _SkierAnimationState createState() => _SkierAnimationState();
}

class _SkierAnimationState extends State<SkierAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 0.08),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Image.asset(
          'assets/water-skier.png',
          width: 290,
        ),
      ),
    );
  }
}
