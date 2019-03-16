import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushReplacementNamed('/');
            }).catchError((e) {
              print(e);
            });
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}
