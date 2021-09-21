import 'package:flutter/material.dart';

class FlagAnimation extends StatefulWidget {
  const FlagAnimation({Key? key}) : super(key: key);

  @override
  _FlagAnimationState createState() => _FlagAnimationState();
}

class _FlagAnimationState extends State<FlagAnimation>
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: Image.asset(
          'assets/flag.png',
          width: 290,
        ),
      ),
    );
  }
}
