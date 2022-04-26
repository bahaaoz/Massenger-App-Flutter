import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/countUsers.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class devPage extends StatefulWidget {
  devPage({Key? key}) : super(key: key);

  @override
  State<devPage> createState() => _devPageState();
}

class _devPageState extends State<devPage> {
  var tempText;
  var tempTextUn;

  var con = TextEditingController();
  final _storage = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Form(
                  child: TextFormField(
                    controller: con,
                    onChanged: ((value) {
                      tempText = value;
                    }),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (tempText == null || tempText == "") {
                    tempText = "bahaa@gmail.com";
                  }
                  _storage.collection('blocklist').add({
                    "emailblock": tempText,
                  });

                  _storage.collection('message').add({
                    "sendar": "BLOCKEDBOOT",
                    "text": "(${tempText}) has been banned",
                    "time": FieldValue.serverTimestamp(),
                  });
                  con.clear();
                },
                child: Text("block"),
              )
            ],
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: Form(
          //         child: TextFormField(
          //           onChanged: ((value) {
          //             tempTextUn = value;
          //           }),
          //         ),
          //       ),
          //     ),
          //     ElevatedButton(
          //       onPressed: () async {
          //         final bahaa =
          //             _storage.collection('blocklist').doc('emailblock');

          //         bahaa.update({tempTextUn: FieldValue.delete()});
          //       },
          //       child: Text("unblock"),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
