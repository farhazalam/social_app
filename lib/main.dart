import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './splash.dart';
import './auth.dart';
import './signup.dart';



void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    
    statusBarColor: Colors.deepOrange[800]
  ));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

 
  @override
  void initState() {
     super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => SplashPage(),
        '/signup': (BuildContext context) => SignupPage(),
        '/login':(BuildContext context) => LoginPage(),
      },

    );
  }
}
