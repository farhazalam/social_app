import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './firebase/CRUD.dart';
import './home.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email = '';
  String _password = '';
  String _name = '';
  String _location = '';
  String _gender = '';
  CRUD _crudFunctions = CRUD();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _designUI() {
    return Container(
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
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'EMAIL',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'PASSWORD',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'FULL NAME',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Name';
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
    );
  }

  Widget _locationField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Location',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Invalid Location';
        }
      },
      onSaved: (value) {
        setState(() {
          _location = value;
          print(_location);
        });
      },
    );
  }

  Widget _genderField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Gender',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey)),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Gender invalid';
        }
      },
      onSaved: (value) {
        setState(() {
          _gender = value;
          print(_gender);
        });
      },
    );
  }

  Widget _confirmButton() {
    return SizedBox(
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () async {
          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();
          FirebaseUser _currentUser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password)
              .catchError((e) {
            print(e.toString());
          });

          await _crudFunctions.uploadUserInfo(
            uid: _currentUser.uid,
            name: this._name,
            email: _currentUser.email,
            location: this._location,
            gender: this._gender,
          );

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return HomePage(_currentUser);
          }));
        },
        elevation: 7.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.deepOrange,
        child: Text('CONFIRM'),
        textColor: Colors.white,
      ),
    );
  }

  Widget backButton() {
    return SizedBox(
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        elevation: 7.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.grey[150],
        child: Text('GO BACK'),
        textColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: <Widget>[
          _designUI(),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _nameField(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _emailField(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _passwordField(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _genderField(),
                  SizedBox(
                    height: 15.0,
                  ),
                  _locationField(),
                  SizedBox(
                    height: 70.0,
                  ),
                  _confirmButton(),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 100)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
