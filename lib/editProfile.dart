import 'package:farmpam/assets.dart';
import 'package:flutter/material.dart';

class editProfilePage extends StatelessWidget {
  String title = 'Edit profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(),
      bottomNavigationBar: footer(context),
    );
  }
}
