import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class cartPage extends StatefulWidget {
  @override
  _cartPageState createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  String title = "My cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
      bottomNavigationBar: footer(context),
    );
  }
}
