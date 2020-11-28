import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class addProductPage extends StatefulWidget {
  @override
  _addProductPageState createState() => _addProductPageState();
}

class _addProductPageState extends State<addProductPage> {
  String title = "Add Product";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title),
      bottomNavigationBar: footer(context),
    );
  }
}
