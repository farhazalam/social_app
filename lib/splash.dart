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
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

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
    return Scaffold(
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/handshake.png',
            height: 60,
            width: 60,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 60*_animation.value,
            width: 150*_animation.value,
            child: Image.asset(
              'assets/ss.png',
              height: 70,
              width: 150,
            ),
          ),
        ],
      )),
    );
  }
}
