import 'package:flutter/material.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );
  late final Animation _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceIn,
  ).drive(
    ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ),
  );
  late final Animation _sizeAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceIn,
  ).drive(
    Tween<double>(
      begin: 1,
      end: 50,
    ),
  );

  bool _animationFinished = false;

  @override
  void initState() {
    super.initState();
    _animationController.addListener(_onAnimationUpdate);
    _animationController.addStatusListener(_onAnimationStatusUpdate);
    _animationController.forward();
  }

  void _onAnimationUpdate() {
    setState(() {});
  }

  void _onAnimationStatusUpdate(AnimationStatus status) {
    setState(() {
      _animationFinished = status == AnimationStatus.completed;
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            color: _animationFinished ? Colors.black : Colors.white,
            child: Text(
              'hello',
              style: TextStyle(
                fontSize: _sizeAnimation.value,
                color: _animation.value,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _animationController
              ..reset()
              ..forward(),
            child: const Text('repeat'),
          ),
        ],
      );

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationUpdate);
    _animationController.removeStatusListener(_onAnimationStatusUpdate);
    _animationController.dispose();
    super.dispose();
  }
}
