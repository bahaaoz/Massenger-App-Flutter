import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class secondpage extends StatefulWidget {
  secondpage({Key? key}) : super(key: key);

  @override
  State<secondpage> createState() => _secondpageState();
}

class _secondpageState extends State<secondpage> {
  final _fireStorage = FirebaseFirestore.instance;
  bool showSopiner = false;

  final _auth = FirebaseAuth.instance;

  late String email;
  late String passwd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSopiner,
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Container(
              height: 200,
              width: 200,
              child: Image.asset("images/signup.jpg"),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(bottom: 10),
              child: Form(
                child: TextFormField(
                  onChanged: ((value) {
                    email = value;
                  }),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Email",
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(bottom: 10),
              child: Form(
                child: TextFormField(
                  onChanged: (value) {
                    passwd = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password",
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    showSopiner = true;
                  });
                  try {
                    final variable = await _auth.createUserWithEmailAndPassword(
                        email: email, password: passwd);

                    Navigator.of(context).pushNamed("signIn");
                    print("wowwwwwwwwwwwwwwwwwwwwwwwww . yeeeeeeeeeeeeeah");
                    setState(() {
                      showSopiner = false;
                    });
                    _fireStorage.collection("emails").add({
                      "email": email.toLowerCase(),
                    });
                    email = "";
                  } catch (e) {
                    setState(() {
                      showSopiner = false;
                    });
                    print(e);
                  }
                },
                child: Text("Sign Up")),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed("signIn");
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
