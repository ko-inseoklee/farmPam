import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class chatPage extends StatefulWidget {
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  //Todo: title will be friend name.
  String title = "chat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      bottomNavigationBar: footer(context),
    );
  }
}
