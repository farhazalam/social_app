import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import './firebase/CRUD.dart';


class EditPage extends StatefulWidget {
  final Map<String, dynamic> _userData;

  EditPage(this._userData);

  @override
  _EditPageState createState() => _EditPageState(_userData);
}

class _EditPageState extends State<EditPage> {
  Map<String, dynamic> _userData;

  _EditPageState(this._userData);
  File _image;
  String id;
  final db = Firestore.instance;
  String urldata;
  bool isloading=false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _newUserData = {
    'name': '',
    'location': '',
    'gender': '',
  };
  CRUD _crudFunctions = CRUD();
  FirebaseUser _currentUser;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
        isloading=true;
      });

      await uploadImage();
    }
  }

  Widget photoField() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
              child:
              CircleAvatar(
                backgroundImage: NetworkImage(urldata),
                radius: 62,
              ),
              ),
          Container(
            child: FloatingActionButton(
              onPressed: () {
                getImage();
              },
              mini: true,
              tooltip: 'Change Photo',
              child: Icon(
                Icons.edit,
                color: Colors.deepOrange,
              ),
              backgroundColor: Colors.white,
            ),
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 2 + 21, 85, 0, 0),
          )
        ],
      ),
    );
  }

  Widget nameField() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Name'),
        onSaved: (value) => _newUserData['name'] = value,
        initialValue: _userData['name'],
      ),
    );
  }

  Widget locationField() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Location'),
        onSaved: (value) {
          _newUserData['location'] = value;
          print(_newUserData['location']);
        },
        initialValue: _userData['location'],
      ),
    );
  }

  Widget genderField() {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Gender'),
        onSaved: (value) => _newUserData['gender'] = value,
        initialValue: _userData['gender'],
      ),
    );
  }

  Future<Null> uploadImage() async {
    _currentUser = await FirebaseAuth.instance.currentUser();
    String uid = _currentUser.uid;
    StorageReference ref = FirebaseStorage.instance.ref().child(uid);
    StorageUploadTask uploadTask = ref.putFile(_image);

    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    setState(() {
      isloading=false;
      urldata = dowurl.toString();
    });
  }

  Future<Null> editData(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _currentUser = await FirebaseAuth.instance.currentUser();

      await _crudFunctions.updateUserName(
        uid: _currentUser.uid,
        newName: this._newUserData['name'],
        newGender: this._newUserData['gender'],
        newLocation: this._newUserData['location'],
        newUrl: this.urldata,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    urldata = _userData['url'];
    isloading=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.check),
                  onTap: () {
                    editData(context);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: Stack(children: <Widget>[ListView(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                photoField(),
                SizedBox(
                  height: 25,
                ),
                nameField(),
                locationField(),
                genderField(),
              ],
            ),
            buildLoading(),
            ],
                       
          ),
        ));
  }
  Widget buildLoading() {
    return Positioned(
      child: isloading
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
}
