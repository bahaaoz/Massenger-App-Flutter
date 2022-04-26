import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:flutter2/rootpage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _fireStore = FirebaseFirestore.instance;
List<String> listEmails = [];
void countUsers() async {
  List<String> listEmailscopy = [];
  listEmails.clear();
  listEmailscopy.clear();
  await for (var messages in _fireStore.collection('emails').snapshots()) {
    for (var a in messages.docs) {
      var temp = a.get('email');

      listEmails.add(temp);
    }
    print(listEmails.length);
    print("hi bahaa");
  }
  // print(listEmailscopy);
  print("dddddd");
  // for (int i = 0; i < listEmailscopy.length - 1; i++) {
  //   listEmails.add(listEmailscopy[i]);
  // }
}
