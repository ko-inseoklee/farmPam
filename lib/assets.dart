import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/signIn.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

Widget header(BuildContext context, String pageTitle, bool isCreater) {
  return AppBar(
    title: Text(pageTitle),
    centerTitle: true,
    actions: [
      // TODO: Change add button to write button.
      IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () => Navigator.pushNamed(context, CART)),
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
  List<String> routeList = [CHATLIST, HOME, ADDPRODUCT];

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
        icon: Icon(Icons.add),
        label: "Write",
      ),
    ],
    //TODO:Change the color proper.
    selectedItemColor: Colors.grey,
    unselectedItemColor: Colors.grey,
    onTap: (index) async {
      if (index == 2) {
        String userDocref = currentUser
            .toString()
            .substring(24, currentUser.toString().length - 1);
        print(userDocref);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userDocref)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          bool isFarmer = documentSnapshot.data()['isVerified'];
          if (isFarmer) {
            Navigator.pushNamed(context, routeList[index]);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Register your farmer location first."),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("cancel"))
                    ],
                  );
                });
          }
        });
      } else {
        Navigator.pushNamed(context, routeList[index]);
      }
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
    leading: documentSnapshot.data()['image'] == ''
        ? Image.network(defaultURL)
        : Image(image: FirebaseImage(documentSnapshot.data()['image'])),
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
