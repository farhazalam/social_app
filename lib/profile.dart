import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './edit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;

  ProfilePage(this.user);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String id;
  Map<String, dynamic> _userData = {
    'name': '',
    'email': '',
    'location': '',
    'gender': '',
    'url': ''
  };
  bool isLoading = false;
  Widget profileUiImage() {
    return Container(
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
              width: 200,
              height: 200.0,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
        imageUrl: _userData['url'],
        width: double.infinity,
        height: 280.0,
        fit: BoxFit.cover,
        
      ),
    );
  }

  Widget profileUiName() {
    return Container(
      child: Text(
        _userData['name'] == null ? '' : _userData["name"].toUpperCase(),
        style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Color.fromARGB(200, 0, 0, 0), offset: Offset(3, 3))
            ]),
      ),
      padding: EdgeInsets.fromLTRB(21, 230, 0, 0),
    );
  }

  Widget profileUiEditButton() {
    return Container(
        padding: EdgeInsets.fromLTRB(330, 242, 0, 0),
        child: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return EditPage(_userData);
            }));
          },
          child: Icon(Icons.edit),
          tooltip: 'Edit',
        ));
  }

  Widget profileUi() {
    return Container(
      child: Stack(
        children: <Widget>[
          profileUiImage(),
          profileUiName(),
          profileUiEditButton(),
        ],
      ),
    );
  }

  Widget emailDisplay() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ListTile(
        title: Text(
          'EMAIL',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          _userData['email'] == null ? '' : _userData['email'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget locationDisplay() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ListTile(
        title: Text(
          'LOCATION',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          _userData['location'] == null ? '' : _userData['location'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget genderDisplay() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: ListTile(
        title: Text(
          'GENDER',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          _userData['gender'] == null ? '' : _userData['gender'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget logoutButton() {
    return Center(
      child: RaisedButton(
        onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.of(context).pushReplacementNamed('/');
          }).catchError((e) {
            print(e);
          });
        },
        child: Text(
          'LOGOUT',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.red,
        elevation: 07,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

  Widget emailVerificationCheck() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Email not Verified ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )),
        Container(
          padding: EdgeInsets.only(bottom: 20),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                widget.user.sendEmailVerification();
                setState(() {
                  isLoading = false;
                  Fluttertoast.showToast(msg: 'Email Sent Successfully');
                });
              },
              child: Text(
                'click Here ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ),
        Container(
          child: Text(
            'to resend.',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          padding: EdgeInsets.only(bottom: 20),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection("USER")
                .document(widget.user.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError)
                return Center(child: Text('Error Loading Data'));

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  _userData['name'] = snapshot.data['name'];
                  _userData['email'] = snapshot.data['email'];
                  _userData['location'] = snapshot.data['location'];
                  _userData['gender'] = snapshot.data['gender'];
                  _userData['url'] = snapshot.data['url'];
                  return Stack(
                    children: <Widget>[
                      ListView(
                        children: <Widget>[
                          profileUi(),
                          emailDisplay(),
                          SizedBox(
                            height: 04,
                          ),
                          locationDisplay(),
                          SizedBox(
                            height: 05,
                          ),
                          genderDisplay(),
                          SizedBox(
                            height: 30,
                          ),
                          logoutButton(),
                        ],
                      ),
                      buildLoading()
                    ],
                  );
              }
            }),
        bottomSheet:
            widget.user.isEmailVerified ? null : emailVerificationCheck());
  }
}
