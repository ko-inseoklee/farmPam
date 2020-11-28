import 'package:farmpam/header.dart';
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String title = "Profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
    );
  }
}
