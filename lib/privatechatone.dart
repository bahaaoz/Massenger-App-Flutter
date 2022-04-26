import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/countUsers.dart';
import 'package:flutter2/rootpage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

int index = 0;

class privateone extends StatefulWidget {
  privateone({Key? key}) : super(key: key);

  @override
  State<privateone> createState() => _privateoneState();
}

class _privateoneState extends State<privateone> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  String serverKey =
      "AAAACk30AFg:APA91bFSyXECtWt62w64AtT0ehtXBrgsA_rt8DbINX0yli7FUedhkcxq6WDe0LsLoF7OLiHyfnr_V30nCgwDhis237ycm0Ta3hT9mTCNCqpRvYEG_Flc4ooZ798VK9htmVvXAVC2wy08";
  sendNotification(String title, String body, String tokenTo) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body.toString(),
            'title': title.toString()
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'to': await tokenTo,
        },
      ),
    );
  }

  void getmass() {
    FirebaseMessaging.onMessage.listen((event) {
      print("=================================================");
      print(event.senderId);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Color.fromARGB(255, 61, 4, 78),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat),
            SizedBox(
              width: 5,
            ),
            Text("BahaaChat"),
          ],
        ),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.arrow_forward),
          //   onPressed: () {
          //     _auth.signOut();
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                "Private Chat",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: listEmails.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5, right: 20, left: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color.fromARGB(255, 55, 69, 77),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            listEmails[i],
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                          userSigned.email != listEmails[i]
                              ? MaterialButton(
                                  color: Colors.blueAccent,
                                  splashColor: Colors.pink,
                                  onPressed: () {
                                    if (userSigned.email != listEmails[i]) {
                                      Navigator.of(context).pushNamed('chat');
                                      setState(() {
                                        index = i;

                                        print(index);
                                      });
                                    }
                                  },
                                  child: Text("massege"),
                                )
                              : Container(
                                  child: Text(
                                    "It's Me ^_^",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 5),
                                ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
