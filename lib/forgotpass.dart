import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  Widget _topdesignUI() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
            child: Text(
              'Forgot',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 175.0, 0.0, 0.0),
            child: Text(
              'Pass',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
           Container(
            padding: EdgeInsets.fromLTRB(15.0, 240.0, 0.0, 0.0),
            child: Text(
              'word',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(220.0, 240.0, 0.0, 0.0),
            child: Text(
              '?',
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
          ),
           Container(
            padding: EdgeInsets.fromLTRB(20.0, 330.0, 0.0, 0.0),
            child: Text(
              'Dont Worry,',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20.0, 353.0, 0.0, 0.0),
            child: Text(
              'we will send you a reset email.',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  )
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

  Widget _sendButton() {
    return Center(
      child: SizedBox(
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
            await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
            this.setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: 'Reset Email Sent Successfully');
            Navigator.of(context).pop();
          },
          elevation: 7.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.deepOrange,
          child: Text('CONFIRM'),
          textColor: Colors.white,
        ),
      ),
    );
  }

  Widget _backButton() {
    return Center(
      child: SizedBox(
        width: 320,
        height: 50,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          elevation: 7.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.grey[150],
          child: Text('GO BACK'),
          textColor: Colors.black,
        ),
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
    return Scaffold(resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topdesignUI(),
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Form(
              key: _formKey,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _emailField(),
                      SizedBox(
                        height: 70.0,
                      ),
                      _sendButton(),
                      SizedBox(
                        height: 15,
                      ),
                      _backButton(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  buildLoading(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
