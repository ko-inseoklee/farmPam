import 'package:farmpam/header.dart';
import 'package:flutter/material.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  String title = "Settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
    );
  }
}
