import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/main.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, String pageTitle, bool isCreater) {
  return AppBar(
    title: Text(pageTitle),
    centerTitle: true,
    actions: [
      // TODO: Change add button to write button.
      isCreater
          ? IconButton(
              icon: Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(context, ADDPRODUCT))
          : Text(""),
      IconButton(
          icon: Icon(Icons.person),
          onPressed: () => Navigator.pushNamed(context, PROFILE)),
      IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => Navigator.pushNamed(context, SETTINGS))
      // TODO: Dropdown will be updated ver1.1
      // DropdownButton<String>(
      //     value: , items: null, onChanged: null)
    ],
  );
}

Widget footer(BuildContext context) {
  List<String> routeList = [CHATLIST, HOME, CART];

  return BottomNavigationBar(
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.chat_bubble_outline),
        label: "Messages",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        label: "My cart",
      ),
    ],
    //TODO:Change the color proper.
    selectedItemColor: Colors.grey,
    unselectedItemColor: Colors.grey,
    onTap: (index) {
      Navigator.pushNamed(context, routeList[index]);
    },
  );
}

Widget buildListTile(BuildContext context, DocumentSnapshot documentSnapshot) {
  String _description = documentSnapshot.data()['description'];
  if (_description.length >= 10) {
    _description = _description.substring(0, 10);
  }

  return ListTile(
    //TODO: getURL after Image upload.
    //TODO: set condition between default and image
    leading: true /*documentSnapshot.data()['name'] == '1'*/
        ? Image.network(defaultURL)
        : Image.network(documentSnapshot.data()['name']),
    title: Text(documentSnapshot.data()['name']),
    subtitle: Text(_description + '...'),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(documentSnapshot.data()['starRating'].toString()),
        Text('₩' + documentSnapshot.data()['price'].toString()),
        Text(documentSnapshot.data()['location']),
      ],
    ),
    onTap: () => Navigator.pushNamed(context, PRODUCTDETAIL,
        arguments: documentSnapshot.reference),
  );
}
