import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter2/countUsers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class firstPage extends StatefulWidget {
  firstPage({Key? key}) : super(key: key);

  @override
  State<firstPage> createState() => _firstPageState();
}

class _firstPageState extends State<firstPage> {
  bool showSpiner = false; //هاج  للتحميل

  final _auth = FirebaseAuth
      .instance; //هاد مشان اعمل اوبجكت من الاوث اللي هي تاعت التسجيل الايميل والخ

  late String email;
  late String passwd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpiner,
        child: Column(children: [
          SizedBox(
            height: 40,
          ),
          Container(
            height: 200,
            width: 200,
            child: Image.asset("images/chat.png"),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(bottom: 10),
            child: Form(
              child: TextFormField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
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
                textAlign: TextAlign.center,
                obscureText: true,
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
                showSpiner = true;
              });
              try {
                final user = await _auth.signInWithEmailAndPassword(
                    //احنا هيك منعمل مشان اجيب القيمه اذا في مستخدم رح يكون معلوماته في اليو
                    //زر فاريبل واذا لا رح يكون اليوزر فاريبل نل
                    email: email,
                    password: passwd);

                if (user != null) {
                  Navigator.of(context).pushNamed("root");
                }
                setState(() {
                  showSpiner = false;
                });
                email = "";
                passwd = "";
                countUsers();
              } catch (e) {
                setState(() {
                  showSpiner = false;
                });
                print(e);
              }
            },
            child: Text("Sign In"),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("signUp");
              },
              child: Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
