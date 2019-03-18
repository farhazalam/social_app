import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './services/usermanagement.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email = '';
  String _password = '';
  String _name = '';
  String _photourl =
      'https://imagesvc.timeincapp.com/v3/fan/image?url=https%3A%2F%2Fculturess.com%2Ffiles%2F2018%2F04%2Ftony-stark.jpg&c=sc&w=850&h=560';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(290.0, 110.0, 0.0, 0.0),
                  child: Text(
                    '.',
                    style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      labelText: 'FULL NAME',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'PASSWORD',
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey)),
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                SizedBox(
                  height: 70.0,
                ),
                SizedBox(
                  width: 320,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((signedInUser) {
                        UserManagement().storeNewUser(signedInUser, context);
                      }).catchError((e) {
                        print(e);
                      });
                    },
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.deepOrange,
                    child: Text('CONFIRM'),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 320,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.grey[150],
                    child: Text('GO BACK'),
                    textColor: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  /*updateUserProfile(UserUpdateInfo userUpdateInfo) async {
    FirebaseUser user = await _auth.currentUser();
    await user.updateProfile(userUpdateInfo).then((user){
      _auth.currentUser().then((user) {
        UserManagement().storeUser(user, context);
      }).catchError((e) {
        print(e.toString());
      });
    });*/
}
