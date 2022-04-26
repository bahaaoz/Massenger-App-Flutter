import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter2/blackListMethod.dart';
import 'package:flutter2/countUsers.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

late User userSigned; //هاد اليوزر اللي سجل معلوماته يعني

User getUserSigned() {
  return userSigned;
}

class rootpage extends StatefulWidget {
  rootpage({Key? key}) : super(key: key);

  @override
  State<rootpage> createState() => _rootpageState();
}

class _rootpageState extends State<rootpage> {
  final _storageCloud = FirebaseFirestore.instance;
  var cloudMassege = FirebaseMessaging.instance;
  final ContolText = TextEditingController();

  String? message;

  bool messageSpinner = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
    countUsers();
    blockMethod();
    cloudMassege.getToken().then((value) async {
      print("............................................");

      print(value);
      print("............................................");
      var tokenTable = await _storageCloud.collection("tokens").get();
      bool check = true;

      for (var x in tokenTable.docs) {
        if (x.get("email") == userSigned.email.toString()) {
          check = false;
          FirebaseFirestore.instance.collection("tokens").doc(x.id).update({
            "tokentext": await cloudMassege.getToken(),
          });
        }
      }
      if (check) {
        _storageCloud.collection("tokens").add({
          "email": userSigned.email.toString(),
          "tokentext": await cloudMassege.getToken(),
        });
      }
    });
  }

  void checkUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        userSigned = user;
      }
      print(userSigned
          .email); //شايف هان كيف دجيب الايميل تاع اليوزر من الاوبجكت اللي عملته
    } catch (e) {
      print(e);
    }
  }

  //هاي لدفع الرسائل من الداتا بيس الى التطبيق
  void getMessages() async {
    await for (var messages
        in _storageCloud.collection('message').snapshots()) {
      for (var mesg in messages.docs) {
        print(mesg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 222, 220, 223),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userSigned.email.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              decoration: BoxDecoration(color: Color.fromARGB(255, 61, 4, 78)),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 252, 252, 252),
                child: Icon(
                  Icons.person,
                  color: Colors.black87,
                  size: 35,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: MaterialButton(
                splashColor: Colors.red,
                color: Color.fromARGB(255, 61, 4, 78),
                textColor: Colors.white,
                onPressed: (() {
                  Navigator.of(context).pop();
                  blockMethod();
                }),
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.public),
                              SizedBox(width: 10),
                              Text("Public Chat"),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: MaterialButton(
                splashColor: Colors.green,
                color: Color.fromARGB(255, 61, 4, 78),
                textColor: Colors.white,
                onPressed: (() {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('privateOne');

                  countUsers();

                  print(listEmails);
                }),
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.lock),
                              SizedBox(width: 10),
                              Text("Private Chat"),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: MaterialButton(
                color: Color.fromARGB(255, 250, 0, 54),
                textColor: Colors.white,
                splashColor: Colors.blue,
                onPressed: (() {
                  Navigator.of(context).pushNamed('whoAm');
                }),
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.science,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "who am I",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              child: MaterialButton(
                onPressed: () {
                  if (userSigned.email == "bahaadev@gmail.com") {
                    Navigator.of(context).pushNamed('devpage');
                  }
                },
                child: Text("Only Dev-Account"),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: MaterialButton(
                splashColor: Colors.green,
                color: Color.fromARGB(255, 61, 4, 78),
                textColor: Colors.white,
                onPressed: (() {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('privateOne');
                  _auth.signOut();
                  Navigator.of(context).pushNamed("signIn");
                  countUsers();
                  print(listEmails);
                }),
                child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.exit_to_app),
                              SizedBox(width: 10),
                              Text("Sign out"),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 61, 4, 78),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Color.fromARGB(255, 255, 17, 0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat),
              SizedBox(
                width: 5,
              ),
              Text("BahaaChat"),
            ],
          ),
        ),
        centerTitle: true,

        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.arrow_forward),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: messageSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Color.fromARGB(255, 48, 51, 1),
              ),
              child: Text(
                "Public Chat",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _storageCloud
                      .collection('message')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    print("im hearee");
                    if (!snapshot.hasData) {
                      return Text('bahaa');
                    }

                    print("im hear");
                    final documantsOfData = snapshot.data!.docs.reversed;

                    //////////////////////////////////////////////////////////////////////////////////
                    List<String> listText = [];
                    List<String> listEmail = [];
                    for (var msg in documantsOfData) {
                      var textMessage = msg.get('text');
                      var textEmail = msg.get("sendar");
                      bool check = false;

                      print(blackList);
                      for (int i = 0; i < blackList.length; i++) {
                        if (textEmail == getListBlock()[i]) {
                          check = true;
                        }
                      }

                      if (!check) {
                        listText.add(textMessage);
                        listEmail.add(textEmail);
                        check = false;
                      }
                    }
                    print(listEmail);
                    // ListView.builder(
                    //   itemCount: listText.length,
                    //   itemBuilder: (context, i) {
                    //     return Container(
                    //       child: Text("data"),
                    //     );
                    //   },
                    // );
                    // print("object1111111111");
                    // print(listText.length);

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: listText.length,
                      itemBuilder: (context, i) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                              crossAxisAlignment:
                                  userSigned.email == listEmail[i]
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  listEmail[i],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          listEmail[i] == "bahaadev@gmail.com"
                                              ? Colors.red
                                              : Colors.black87),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 15, top: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: userSigned.email == listEmail[i]
                                          ? Color.fromARGB(255, 28, 128, 211)
                                          : Colors.black26,
                                      borderRadius: userSigned.email ==
                                              listEmail[i]
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10))
                                          : BorderRadius.only(
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topRight: Radius.circular(10))),
                                  child: Text(
                                    listText[i],
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                ),
                              ]),
                        );
                      },
                    );
                  }),
            ),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: TextFormField(
                      controller: ContolText,
                      onChanged: ((value) {
                        message = value;
                      }),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.message),
                        prefixIconColor: Color.fromARGB(255, 61, 4, 78),
                        border: UnderlineInputBorder(),
                        hintText: "write here",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      ContolText.clear();
                      print("wowwww");
                      getMessages();

                      setState(() {
                        messageSpinner = true;
                      });
                      if (message == null) message = '.';
                      _storageCloud.collection('message').add({
                        "text": message,
                        "sendar": userSigned.email,
                        "time": FieldValue.serverTimestamp(),
                      });
                      setState(() {
                        messageSpinner = false;
                      });
                    },
                    icon: Icon(Icons.send),
                    color: Color.fromARGB(255, 61, 4, 78),
                    iconSize: 24,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
