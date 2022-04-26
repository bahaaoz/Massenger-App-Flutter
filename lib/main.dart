import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/chat.dart';
import 'package:flutter2/devpage.dart';
import 'package:flutter2/firstpage.dart';
import 'package:flutter2/privatechatone.dart';
import 'package:flutter2/rootpage.dart';
import 'package:flutter2/secondpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter2/whoami.dart';

Future message1(RemoteMessage rm) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(message1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "signIn": (context) => firstPage(),
        "signUp": (context) => secondpage(),
        "root": (context) => rootpage(),
        "privateOne": (context) => privateone(),
        "chat": (context) => chat(),
        "whoAm": (context) => whoam(),
        "devpage": (context) => devPage(),
      },
      initialRoute: _auth.currentUser != null ? "root" : "signIn",
      debugShowCheckedModeBanner: false,
      home: const Scaffold(),
    );
  }
}
