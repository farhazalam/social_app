import 'package:flutter/material.dart';


import './auth.dart';
import './signup.dart';
import './home.dart';
import './messages.dart';
import './profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context)=>LoginPage(),
        '/signup': (BuildContext context) =>SignupPage(),
        '/home':(BuildContext context) => HomePage(),
        '/messagepage':(BuildContext context ) => MessagePage(),
        '/profilepage':(BuildContext context ) => ProfilePage(),
      },

    );
  }
  
}
