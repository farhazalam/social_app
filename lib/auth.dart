import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  SharedPreferences prefs;
  bool isLoading = false;
  bool isLoggedIn = false;
  
  @override
  void initState() {
    super.initState();
    
    isSignedIn();
  }

  Future<FirebaseUser> getUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();

    getUser().then((user) {
      if (user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
          return HomePage(user);
        }));
      }
    });

    this.setState(() {
      isLoading = false;
    });
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
          this.setState(() {
            isLoading = true;
          });
          _formKey.currentState.save();
          FirebaseUser _currentUser = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password)
              .catchError((e) {
            Fluttertoast.showToast(msg: 'Enter Correct Details');
            this.setState(() {
              isLoading = false;
            });
            print(e.toString());
          });
          StreamBuilder(
            stream: Firestore.instance
                .collection('USER')
                .document(_currentUser.uid)
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
                prefs.setString('id', snapshot.data['id']);
                prefs.setString('name', snapshot.data['name']);
                prefs.setString('url', snapshot.data['url']);
              }
            },
          );
          Fluttertoast.showToast(msg: 'You are logged in');
          this.setState(() {
            isLoading = false;
          });
          if (_currentUser == null)
            print("USER is null");
          else {
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
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                      child: isLoading == true
                          ? Container(
                              color: Colors.white.withOpacity(0.8),
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)),
                              ),
                            )
                          : Container())
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
