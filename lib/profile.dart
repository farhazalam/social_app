import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './edit.dart';

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
  };
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
                  return ListView(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: Image.asset('assets/dp.jpg'),
                            ),
                            Container(
                              child: Text(
                                _userData["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                          color: Color.fromARGB(200, 0, 0, 0),
                                          offset: Offset(3, 3))
                                    ]),
                              ),
                              padding: EdgeInsets.fromLTRB(21, 230, 0, 0),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(330, 242, 0, 0),
                                child: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return EditPage(_userData);
                                    }));
                                  },
                                  child: Icon(Icons.edit),
                                  tooltip: 'Edit',
                                ))
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: ListTile(
                          title: Text(
                            'EMAIL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            _userData['email'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 04,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: ListTile(
                          title: Text(
                            'LOCATION',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            _userData['location'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 05,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: ListTile(
                          title: Text(
                            'GENDER',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            _userData['gender'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      )
                    ],
                  );
              }
            }));
  }
}
