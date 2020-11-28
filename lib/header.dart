import 'package:farmpam/main.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, String pageTitle) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.person),
      onPressed: () => Navigator.pushNamed(context, PROFILE),
    ),
    title: Text(pageTitle),
    centerTitle: true,
    actions: [
      // TODO: Change add button to write button.
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, ADDPRODUCT)),
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, SETTINGS))
      // TODO: Dropdown will be updated ver1.1
      // DropdownButton<String>(
      //     value: , items: null, onChanged: null)
    ],
  );
}
