import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference products =
      FirebaseFirestore.instance.collection("product");

  String title = 'Main page';

  String get documentId => null;

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;
    print("currentuser == $currentUser");

    return Scaffold(
      appBar: header(context, title),
      body: ListView(
        children: <Widget>[
          Container(
            child: Text("Search"),
          ),
          Center(
            child: SizedBox(
              height: 80,
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: products.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    if (snapshot.hasError) {
                      print('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("loading");
                    }

                    return ListTile(
                      //Todo: fill component in Listtile Lee
                      title: Text(document.data()['name']),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
