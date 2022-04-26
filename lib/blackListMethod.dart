import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/countUsers.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

final _storageCloud = FirebaseFirestore.instance;

List<String> blackList = [];
void blockMethod() async {
  //List<String> listEmailscopy = [];
  blackList.clear();
  print('block methosssssssssssssssss');
  await for (var messages
      in _storageCloud.collection('blocklist').snapshots()) {
    for (var a in messages.docs) {
      var temp = a.get('emailblock');
      print("hi bahaa22222222");
      blackList.add(temp);
    }
    print('ssssss');
    print(blackList.length);
    print(blackList);
  }
  // print(listEmailscopy);
  print("dddddd");
  // for (int i = 0; i < listEmailscopy.length - 1; i++) {
  //   listEmails.add(listEmailscopy[i]);
  // }
}

List<String> getListBlock() {
  print(blackList);
  return blackList;
}

int getListLength() {
  return blackList.length;
}
