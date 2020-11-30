import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';

import 'main.dart';

List<dynamic> cartList;

List<String> _name = new List<String>();
List<String> _image = new List<String>();
List<String> _location = new List<String>();
List<String> _description = new List<String>();
List<String> _starRating = new List<String>();
List<String> _price = new List<String>();

Stream<QuerySnapshot> product =
    FirebaseFirestore.instance.collection("product").snapshots();

class cartPage extends StatefulWidget {
  @override
  _cartPageState createState() => _cartPageState();
}

class _cartPageState extends State<cartPage> {
  String title = "My cart";

  @override
  Widget build(BuildContext context) {
    //this statement will be inserted in the builder.
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.id)
        .get()
        .then((DocumentSnapshot snapshot) async {
      cartList = await snapshot.data()['cart'];
    });

    print("cartlist == $cartList");

    return Scaffold(
      appBar: header(context, title, true),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) {
          //
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection("product")
              .doc(cartList.elementAt(index));

          DocumentSnapshot documentSnapshot;
          FirebaseFirestore.instance.runTransaction((transaction) async {
            documentSnapshot = await transaction.get(documentReference);

            _name.add(documentSnapshot.data()['name']);
            _price.add(documentSnapshot.data()['price'].toString());
            _starRating.add(documentSnapshot.data()['starRating'].toString());
            _location.add(documentSnapshot.data()['location']);
            _image.add(documentSnapshot.data()['image']);
            String temp = documentSnapshot.data()['description'];
            if (temp.length >= 10) {
              temp = temp.substring(0, 10) + '...';
            } else {
              temp = temp + '...';
            }
            _description.add(temp);
          });
          return ListTile(
            //TODO: getURL after Image upload.
            //TODO: set condition between default and image
            leading: true /*documentSnapshot.data()['name'] == '1'*/
                ? Image.network(defaultURL)
                : Image.network(documentSnapshot.data()['name']),
            title: Text(_name.elementAt(index)),
            subtitle: Text(_description.elementAt(index)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_starRating.elementAt(index)),
                Text('₩' + _price.elementAt(index)),
                Text(_location.elementAt(index)),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, PRODUCTDETAIL,
                arguments: documentSnapshot.reference),
            onLongPress: () {
              print("delete");
            },
          );
        },
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
