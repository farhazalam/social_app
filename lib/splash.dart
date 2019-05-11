import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animation.addListener(() {
      if (_animation.status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
      setState(() {});
    });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.deepOrange[400],
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.centerLeft,end: Alignment.centerRight,
                  colors: [Color(0xffee0979), Color(0xffff6a00)])),
          child: Text(
            'All Friends',
            style: TextStyle(fontSize: 30),
          ),
          height: _animation.value * 100,
          width: _animation.value * 100,
        ),
      ),
    );
  }
}
