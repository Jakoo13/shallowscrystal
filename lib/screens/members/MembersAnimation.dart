import 'package:flutter/material.dart';

class MembersAnimation extends StatefulWidget {
  const MembersAnimation({Key? key}) : super(key: key);

  @override
  _MembersAnimationState createState() => _MembersAnimationState();
}

class _MembersAnimationState extends State<MembersAnimation>
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
          'assets/users.png',
          width: 290,
        ),
      ),
    );
  }
}
