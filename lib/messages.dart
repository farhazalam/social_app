import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';


import './chat.dart';
import './dashboard.dart';

class MessagePage extends StatefulWidget {
  final FirebaseUser user;
  MessagePage(this.user);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  DashboardPageState appbar=DashboardPageState();
  String title='Messages';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appbar.customAppBar(title),
        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance.collection('USER').snapshots(),
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
                  padding: EdgeInsets.all(7.0),
                  itemBuilder: (context, index) =>
                      buildItem(context, snapshot.data.documents[index]),
                  itemCount: snapshot.data.documents.length,
                );
              }
            },
          ),
        ));
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document['id'] == widget.user.uid) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
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
                  imageUrl: document['url'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${document['name']}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
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
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return Chat(
                user: widget.user,
                friendId: document.documentID,
               friendImage: document['url'],
              );
            }));
          },
          color: Colors.grey[200],
          padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

