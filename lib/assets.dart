import 'package:farmpam/main.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, String pageTitle) {
  return AppBar(
    title: Text(pageTitle),
    centerTitle: true,
    actions: [
      // TODO: Change add button to write button.
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, ADDPRODUCT)),
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
