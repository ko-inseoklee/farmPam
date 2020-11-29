import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection("users");

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String title = 'Main page';

  String get documentId => null;

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshots) {
    return ListView(
        shrinkWrap: true,
        children:
            snapshots.map((data) => buildListTile(context, data)).toList());
  }

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;
    print("currentuser == $currentUser");
    Stream<QuerySnapshot> product =
        FirebaseFirestore.instance.collection("product").snapshots();

    return Scaffold(
      appBar: header(context, title, true),
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
              stream: product,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return LinearProgressIndicator();
                return _buildList(context, snapshot.data.docs);
                /*return ListView(
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
                      onTap: () => Navigator.pushNamed(context, PRODUCTDETAIL,
                          arguments: document.reference),
                    );
                  }).toList(),
                );*/
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
