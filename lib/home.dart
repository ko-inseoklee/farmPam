import 'package:flutter/material.dart';

import 'header.dart';

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String title = 'Main page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
      body: Text("this is home page!"),
    );
  }
}
