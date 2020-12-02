import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'cart.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection("users");

//cartpage에 쓸 데이터.
List<dynamic> cartList = new List<dynamic>();

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

    if (currentUser == null) {
      users.add({
        'address': "",
        'cart': [],
        'chatList': [],
        'favorite': [],
        'like': [],
        'isVerified': true,
        'nickName': user.displayName,
        'sellingProducts': [],
        'uid': user.uid,
        'farmDescription': '',
        'farmImage': '',
        'farmReview': [],
        'farmName': '',
        'farmLocation': '',
        'image': '',
      }).then((value) => {currentUser = value});
    }
    print("home currentuser == $currentUser");

    print(cartList);
    print(name);
    print(description);

    Stream<QuerySnapshot> product =
        FirebaseFirestore.instance.collection("product").snapshots();

    //cart page에 필요한 데이터.
    setState(() {
      setData();
    });

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

  Future<void> setData() async {
    String userdoc =
        currentUser.toString().substring(24, currentUser.toString().length - 1);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userdoc)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      int len = documentSnapshot.data()['cart'].length;

      cartList.removeRange(0, cartList.length);

      for (int i = 0; i < len; i++) {
        cartList.insert(i, documentSnapshot.data()['cart'][i]);
      }
    });

    if (cartList.length != name.length) {
      name.removeRange(0, name.length);
      image.removeRange(0, image.length);
      location.removeRange(0, location.length);
      starRating.removeRange(0, starRating.length);
      price.removeRange(0, price.length);
      description.removeRange(0, description.length);
      for (int i = 0; i < cartList.length; i++) {
        await FirebaseFirestore.instance
            .collection("product")
            .doc(cartList[i])
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          name.add(documentSnapshot.data()['name']);
          image.add(documentSnapshot.data()['image']);
          location.add(documentSnapshot.data()['location']);
          starRating.add(documentSnapshot.data()['starRating'].toString());
          price.add(documentSnapshot.data()['price'].toString());
          String temp = documentSnapshot.data()['description'];
          if (temp.length >= 10) {
            temp = temp.substring(0, 10) + "...";
          } else {
            temp = temp + "...";
          }
          description.add(temp);
          productRef.add(documentSnapshot.reference);
        });
      }
    }
  }
}
