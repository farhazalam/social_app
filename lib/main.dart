import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './auth.dart';
import './signup.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  final FirebaseMessaging _messaging=FirebaseMessaging();
  @override
  void initState() {
     super.initState();
    _messaging.getToken().then((token){print(token);});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/signup': (BuildContext context) => SignupPage(),
       // '/messagepage': (BuildContext context) => MessagePage(),
        // '/editpage': (BuildContext context) => EditPage(),
      },

    );
  }
}
