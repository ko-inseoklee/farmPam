import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String title = 'Main page';
  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;

    print(user);

    return Scaffold(
      appBar: header(context, title),
      body: Text(""),
      bottomNavigationBar: footer(context),
    );
  }
}
