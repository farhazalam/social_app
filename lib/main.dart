import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './auth.dart';
import './signup.dart';
import './home.dart';
import './messages.dart';
import './profile.dart';
import './edit.dart';

void main() {
// FirebaseUser _currentuser=await FirebaseAuth.instance.currentUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
        '/messagepage': (BuildContext context) => MessagePage(),
       // '/editpage': (BuildContext context) => EditPage(),
      },
    );
  }
}
