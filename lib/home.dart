import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './profile.dart';
import './messages.dart';
import './dashboard.dart';
import './firebase/CRUD.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;

  HomePage(this.user);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  CRUD tokencrud = new CRUD();
  String name;
  String url;
  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      tokencrud.updateToken(token: token, uid: widget.user.uid);
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.deepOrange[300],
          elevation: 7.0,
          child: Material(
            color: Colors.deepOrange,
            child: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.message)),
                Tab(
                  icon: Icon(Icons.portrait),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DashboardPage(widget.user),
            MessagePage(widget.user),
            ProfilePage(widget.user)
          ],
        ),
      ),
    );
  }
}
