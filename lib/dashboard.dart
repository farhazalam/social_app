import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  File imageFile;
  bool isLoading;
  String imageUrl;
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

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void onSendPost(String content1, int type) async {
    DocumentSnapshot snap = await Firestore.instance
        .collection("USER")
        .document(widget.user.uid)
        .get();
    name = snap['name'];
    url = snap['url'];
    crud.uploadPost(
        uid: widget.user.uid,
        content: content1,
        type: type,
        name: snap['name'],
        url: snap['url']);
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;

      setState(() {
        isLoading = false;
        content = imageUrl;
      });
      onSendPost(content, 1);
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
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
              onPressed: getImage,
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
              onPressed: () {
                onSendPost(content, 0);
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
    isLoading = false;
    super.initState();
  }

  
  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.only(bottom: 7),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5,),
          Material(elevation: 3,
                      child: Column(
              children: <Widget>[
                Divider(
                  height: 5,
                ),
                Row(
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
                        width: 42.0,
                        height: 42.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${document['name']}',
                            style:
                                TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
                        ),
                        Container(
                          child: Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document['time']))),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                document['type'] == 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(right: 5),
                        child: Text(
                          '${document['content']}',
                          maxLines: 5,
                          style: TextStyle(fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      )
                    : Container(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                          imageUrl: document['content'],
                          width: MediaQuery.of(context).size.width - 20,
                          height: 200.0,
                          fit: BoxFit.contain,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
    Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
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
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildPostBox(),
                Expanded(
                    child: Container(
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('POSTS')
                        .orderBy('time', descending: true)
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
             buildLoading(),
          ],
        ),
      ),
    );
  }

}
