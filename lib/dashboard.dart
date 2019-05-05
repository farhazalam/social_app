import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String title = 'News Feed';
  Widget customAppBar(String s) {
    return PreferredSize(
      preferredSize: Size.fromHeight(55),
      child: Stack(
        children: <Widget>[
          Material(
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.deepOrange[300],
                Colors.deepOrange[400],
                Colors.deepOrange,
                Colors.deepOrange[600],
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
            ),
          ),
          AppBar(
            title: Text(s),
            backgroundColor: Colors.transparent,
            elevation: 0,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title),
      
    );
  }
}
