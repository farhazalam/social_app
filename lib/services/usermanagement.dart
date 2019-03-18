import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
class UserManagement {
  storeNewUser(user,context) {
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid
    }).then((value) {
      //Navigator.of(context).pop();
      //Navigator.of(context).pushReplacementNamed('/home');
      Navigator.of(context).pop();
    }).catchError((e) {
      print(e);
    });
  }
}
