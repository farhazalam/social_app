import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String id;
  final db = Firestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _newUserData = {
    'name': '',
    'location': '',
    'gender': '',
  };
  CRUD _crudFunctions = CRUD();
  FirebaseUser _currentUser;

  TextFormField buildTextFieldName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      onSaved: (value) => _newUserData['name'] = value,
      initialValue: _userData['name'],
    );
  }

  Future<Null> editData(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _currentUser = await FirebaseAuth.instance.currentUser();
      await _crudFunctions.updateUserName(
          uid: _currentUser.uid,
          newName: this._newUserData['name'],
          newGender: this._newUserData['gender'],
          newLocation: this._newUserData['location']);
      print('DATA OLD $_userData');
      print('DATA NEW $_newUserData');
      Navigator.of(context).pop();
    }
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
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/dp.jpg'),
                        radius: 62,
                      ),
                    ),
                    Container(
                      child: FloatingActionButton(
                        onPressed: () {},
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
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: buildTextFieldName(),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Location'),
                  onSaved: (value) {
                    
                      _newUserData['location'] = value;
                      print(_newUserData['location']);
                   
                  },
                  initialValue: _userData['location'],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Gender'),
                  onSaved: (value) => _newUserData['gender'] = value,
                  initialValue: _userData['gender'],
                ),
              ),
            ],
          ),
        ));
  }
}
