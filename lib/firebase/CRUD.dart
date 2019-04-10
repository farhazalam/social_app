import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUD {
  Firestore database = Firestore.instance;

  Future<Null> uploadUserInfo(
      {@required String uid,
      @required String name,
      @required String email,
      @required String location,
      @required String gender}) async {
    Map<String, dynamic> _userData = {
      'name': name,
      'email': email,
      'location': location,
      'gender': gender,
    };
    await database.collection("USER").document(uid).setData(_userData);
  }

  Future<Null> updateUserName(
      {@required String uid, @required String newName,@required String newGender,@required String newLocation}) async {
  
    Map<String, String> _newData = {'name': newName,'gender': newGender,'location': newLocation};

    await database
        .collection("USER")
        .document(uid)
        .setData(_newData, merge: true);
  }
}
