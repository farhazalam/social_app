import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _topdesignUI() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
            child: Text(
              'Hello',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
            child: Text(
              'There',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
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
            color: Colors.grey),
      ),
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

  Widget _loginButton() {
    return SizedBox(
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () async {
          if (!_formKey.currentState.validate()) {
            return;
          }

          _formKey.currentState.save();
       //   CircularProgressIndicator();
          FirebaseUser _currentUser = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password)
              .catchError((e) {
            print(e.toString());
          });
          if (_currentUser == null)
            print("USER is null");
          else
          { CircularProgressIndicator();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return HomePage(_currentUser);
            }));
          }
        },
        elevation: 7.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.deepOrange,
        child: Text('LOGIN'),
        textColor: Colors.white,
      ),
    );
  }

  Widget _signupButton() {
    return SizedBox(
      width: 320,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/signup');
        },
        elevation: 7.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.grey[150],
        child: Text('SIGN UP'),
        textColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topdesignUI(),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _emailField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _passwordField(),
                  SizedBox(
                    height: 70.0,
                  ),
                  _loginButton(),
                  SizedBox(
                    height: 15,
                  ),
                  _signupButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
