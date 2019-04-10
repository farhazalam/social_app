import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './profile.dart';
import './messages.dart';
import './dashboard.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage(this.user); 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.deepOrange[300],
          elevation: 7.0,
          child: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.message)),
              Tab(
                icon: Icon(Icons.portrait),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[DashboardPage(), MessagePage(), ProfilePage(widget.user)],
        ),
      ),
    );
  }
}
