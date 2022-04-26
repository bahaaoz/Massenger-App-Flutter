import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/countUsers.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:flutter2/rootpage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class chat extends StatefulWidget {
  chat({Key? key}) : super(key: key);

  @override
  State<chat> createState() => _chatState();
}

class _chatState extends State<chat> {
  final _storage = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

//ميثود ل جلب الرسائل

  // void getMessages() async {
  //   await for (var doc1 in _storage.collection('emails').snapshots()) {
  //     for(var doc2 in doc1.docs){
  //       if(userSigned.email == doc2.get('email')){

  //       }
  //     }
  //   }
  // }

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

    // FirebaseMessaging.onMessage.listen((event) {
    //   print(event.notification?.title);
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // FirebaseMessaging.onMessage.listen((event) {
    //   print(event.notification?.title);
    // });
  }

  var textMassege;
  var txetControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${listEmails[index]}"),
        backgroundColor: Color.fromARGB(255, 231, 57, 86),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _storage
                    .collection('privatemessage')
                    .orderBy('time')
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    //هان بعمل تشيك على السنابشوت اذا في معلومات يعني في رسائل او لا
                    return Center(
                      child: Text("No Massege"),
                    );
                  }

                  final tempDoc = snapshot.data!.docs
                      .reversed; //هاي اللي بتجيب الدوكيومنتس من الفيربيس

                  List<String> messageText = [];
                  List<String> messageSendar = [];
                  List<String> messageReceiver = [];
                  for (var getDoc in tempDoc) {
                    var massegeTextTemp = getDoc.get('text');
                    var messageSendarTemp = getDoc.get('sendar');
                    var messageReceiverTemp = getDoc.get('receiver');
                    if ((messageSendarTemp == userSigned.email &&
                            messageReceiverTemp == listEmails[index]) ||
                        messageReceiverTemp == userSigned.email &&
                            messageSendarTemp == listEmails[index]) {
                      messageText.add(massegeTextTemp);
                      messageSendar
                          .add(messageSendarTemp.toString().toLowerCase());
                      messageReceiver
                          .add(messageReceiverTemp.toString().toLowerCase());
                    }
                  }
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //
                  //

                  return ListView.builder(
                    reverse: true,
                    itemCount: messageText.length,
                    itemBuilder: (txt, i) {
                      return Container(
                        child: Column(
                          crossAxisAlignment:
                              messageSendar[i] == userSigned.email
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    messageSendar[i] == userSigned.email
                                        ? BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          )
                                        : BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                color: messageSendar[i] == userSigned.email
                                    ? Colors.blue
                                    : Colors.black26,
                              ),
                              padding: EdgeInsets.all(6),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text("${messageText[i]}"),
                            ),
                          ],
                        ),
                      ); ///////////////////////////////////////////////////////
                    },
                  );
                }),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        child: TextFormField(
                          controller: txetControl,
                          onChanged: (value) {
                            textMassege = value;
                          },
                          decoration: InputDecoration(
                            hintText: "write here",
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (textMassege != null && textMassege != "") {
                        _storage.collection('privatemessage').add({
                          "text": textMassege,
                          "receiver": listEmails[index],
                          "sendar": userSigned.email,
                          "time": FieldValue.serverTimestamp(),
                        });
                        String tempToken = "";
                        txetControl.clear();
                        var notify = await _storage.collection("tokens").get();
                        for (var i in notify.docs) {
                          if (i.get("email") == listEmails[index]) {
                            tempToken = i.get("tokentext");
                          }
                        }
                        //Notification
                        sendNotification("لديك رساله جديده ",
                            " من ${userSigned.email}", tempToken);
                      }
                      textMassege = "";
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
