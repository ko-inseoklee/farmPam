import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  //Todo: title will be friend name.
  String title = "Profile";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      bottomNavigationBar: footer(context),
    );
  }
}
