import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CRUD {
  Firestore database = Firestore.instance;

  Future<Null> uploadUserInfo(
      {@required String uid,
      @required String name,
      @required String email,
      @required String location,
      @required String gender,
      @required String url}) async {
    Map<String, dynamic> _userData = {
      'id': uid,
      'name': name,
      'email': email,
      'location': location,
      'gender': gender,
      'url': url
    };
    await database.collection("USER").document(uid).setData(_userData);
  }

  Future<Null> updateUserName(
      {@required String uid,
      @required String newName,
      @required String newGender,
      @required String newLocation,
      @required String newUrl}) async {
    Map<String, String> _newData = {
      'name': newName,
      'gender': newGender,
      'location': newLocation,
      'url': newUrl
    };

    await database
        .collection("USER")
        .document(uid)
        .setData(_newData, merge: true);
  }

  Future<Null> updateToken(
      {@required String token, @required String uid}) async {
    Map<String, String> _tokendata = {'tokendata': token};
    await database
        .collection('USER')
        .document(uid)
        .setData(_tokendata, merge: true);
  }

  Future<Null> uploadPost(
      {@required String uid,
      @required String content,
      @required int type,@required name,@required url}) async {
    Map<String, dynamic> _uploadData = {
      'id': uid,
      'content': content,
      'type': type,
      'time': DateTime.now().millisecondsSinceEpoch.toString(),
      'name':name,
      'url':url,
    };
    await Firestore.instance
        .collection('POSTS')
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData(_uploadData);
  }
}
