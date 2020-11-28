import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

DocumentReference currentUser;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String title = 'Main page';

  String get documentId => null;

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;
    // print(user);

    bool containsID = false;

    CollectionReference users = FirebaseFirestore.instance.collection("users");

    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("something wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("wait..");
        }

        snapshot.data.docs.map((DocumentSnapshot document) {
          String temp = document.data()['uid'];
          if (temp == user.uid) {
            currentUser = document.reference;
            containsID = true;
          }
        }).toList();

        if (!containsID) {
          users.add({
            'address': "",
            'cart': "",
            'chatList': [],
            'description': '',
            'favorite': [],
            'like': [],
            'isVerified': true,
            'location': '',
            'nickName': user.displayName,
            'sellingProducts': [],
            'uid': user.uid
          }).then((value) => currentUser = value);
        }

        return Scaffold(
          appBar: header(context, title),
          // body: new ListView(
          //   children: snapshot.data.docs.map((DocumentSnapshot document) {
          //     return new ListTile(
          //       title: new Text(document.data()['nickName']),
          //     );
          //   }).toList(),
          // ),
          body: Text("test"),
          bottomNavigationBar: footer(context),
        );
      },
    );
  }
}
