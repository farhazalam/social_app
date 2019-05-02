import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './firebase/CRUD.dart';
import './home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isloading = false;
  SharedPreferences prefs;
  String _email = '';
  String _password = '';
  String _name = '';
  String _location = '';
  String _gender = '';
  CRUD _crudFunctions = CRUD();
  File _image;
  String url;
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
          labelText: 'PASSWORD.',
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
          this.setState(() {
            isloading = true;
          });
          _formKey.currentState.save();
          FirebaseUser _currentUser = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: _email, password: _password)
              .catchError((e) {
            this.setState(() {
              isloading = false;
            });
            Fluttertoast.showToast(msg: 'Incorrect Details');
            print(e.toString());
          });
          String uid = _currentUser.uid;
          StorageReference ref = FirebaseStorage.instance.ref().child(uid);
          StorageUploadTask uploadTask = ref.putFile(_image);

          var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
          url = dowurl.toString();
    
          await _crudFunctions.uploadUserInfo(
              uid: _currentUser.uid,
              name: this._name,
              email: _currentUser.email,
              location: this._location,
              gender: this._gender,
              url: url);

          //FirebaseStorage.instance.ref().child(uid).putFile(_image);

          print(url);
          this.setState(() {
            isloading = false;
          });
          Fluttertoast.showToast(msg: 'SignUp Successful');
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget photoField() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Colors.orange,
              backgroundImage: _image == null
                  ? AssetImage('assets/dp.jpg')
                  : FileImage(_image),
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
                MediaQuery.of(context).size.width / 2 + 15, 75, 0, 0),
          )
        ],
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
                  SizedBox(
                    height: 15,
                  ),
                  photoField(),
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
                  backButton(),
                  Center(
                      child: isloading == true
                          ? Container(
                              color: Colors.white.withOpacity(0.8),
                              child: Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)),
                              ),
                            )
                          : Container()),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
