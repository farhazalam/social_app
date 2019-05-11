import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './helpers/ensure_visible.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './firebase/CRUD.dart';

class DashboardPage extends StatefulWidget {
  final FirebaseUser user;
  DashboardPage(this.user);
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  String title = 'News Feed';
  FocusNode _focusNode = FocusNode();
  CRUD crud = CRUD();
  String content;
  String name, url;
  TextEditingController _textFieldController = TextEditingController();
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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildPostBox() {
    return Container(
      width: double.infinity,
      height: 45,
      child: Row(
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(
                Icons.image,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
          ),
          Flexible(
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.grey[100]),
              child: TextField(
                onChanged: (s) {
                  setState(() {
                    content = s;
                  });
                },
                style: TextStyle(fontSize: 15.0),
                controller: _textFieldController,
                scrollPadding: EdgeInsets.only(top: 10),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: InputBorder.none,
                  hintText: '   Tell everyone how you feel?',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                focusNode: _focusNode,
              ),
            ),
          ),
          Container(
            child: IconButton(
              onPressed: () async {
                DocumentSnapshot snap = await Firestore.instance
                    .collection("USER")
                    .document(widget.user.uid)
                    .get();
                name = snap['name'];
                url = snap['url'];
                crud.uploadPost(
                    uid: widget.user.uid,
                    content: content,
                    type: 0,
                    name: snap['name'],
                    url: snap['url']);
              },
              icon: Icon(
                Icons.send,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        onHorizontalDragDown: (drag) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: <Widget>[
            buildPostBox(),
            Expanded(
                child: Container(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('POSTS')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      padding: EdgeInsets.all(7),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data.documents[index]),
                    );
                  }
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
              errorWidget: (context, s, url) => Container(),
              imageUrl: document['url'],
              width: 50.0,
              height: 50.0,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            clipBehavior: Clip.hardEdge,
          ),
          Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${document['name']}',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                
                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),  
          
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${document['content']}',maxLines: 5,
                        style: TextStyle(
                           
                            fontSize: 18),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: 10.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}
