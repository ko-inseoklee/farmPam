import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class chatListPage extends StatefulWidget {
  @override
  _chatListPageState createState() => _chatListPageState();
}

class _chatListPageState extends State<chatListPage> {
  //Todo: title will be friend name.
  String title = "chat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
      bottomNavigationBar: footer(context),
    );
  }
}
