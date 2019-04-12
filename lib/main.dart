import 'package:flutter/material.dart';

import './auth.dart';
import './signup.dart';

import './messages.dart';

void main() {
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

//home: inputData(),
    );
  }
  // void inputData() async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   final uid = user.uid;
  //   FutureBuilder<FirebaseUser>(
  //    future: FirebaseAuth.instance.currentUser(),

  //    builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {

  //       switch (snapshot.connectionState) {
  //           case ConnectionState.none:
  //           case ConnectionState.waiting:
  //              return CircularProgressIndicator();
  //           default:
  //              if (snapshot.hasError)
  //                 return Text('Error: ${snapshot.error}');
  //              else
  //                if(snapshot.data == null)
  //                   return LoginPage();
  //                else
  //                   return HomePage(user);
  //       }

  //    }
  // );

  // }
}
