import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/productDetail.dart';
import 'package:farmpam/signIn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'main.dart';

class cartPage extends StatefulWidget {
  @override
  _cartPageState createState() => _cartPageState();
}

List<String> name = new List<String>();
List<String> image = new List<String>();
List<String> location = new List<String>();
List<String> description = new List<String>();
List<String> starRating = new List<String>();
List<String> price = new List<String>();
List<DocumentReference> productRef = new List<DocumentReference>();

class _cartPageState extends State<cartPage> {
  //Todo: title will be friend name.
  String title = "cart";

  _showDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete on your cart?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    setState(() {
                      //TODO: Delete element of cartlist
                      name.removeAt(index);
                      image.removeAt(index);
                      location.removeAt(index);
                      starRating.removeAt(index);
                      price.removeAt(index);
                      cartList.removeAt(index);

                      String userDoc = currentUser
                          .toString()
                          .substring(24, currentUser.toString().length - 1);
                      print("cart userDoc == userDoc");

                      //TODO: Delete element of database or update current cartlist
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(userDoc)
                          .update({'cart': cartList}).then(
                              (value) => print("update successfully."));
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Delete")),
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    //User의 cartList 받아오기.

    print(cartList);
    print(name);
    print(description);

    return Scaffold(
      appBar: header(context, title, true),
      body: ListView.builder(
        itemCount: cartList.length,
        itemBuilder: (context, index) {
          return ListTile(
            //TODO: getURL after Image upload.
            //TODO: set condition between default and image
            leading: true /*documentSnapshot.data()['name'] == '1'*/
                ? Image.network(defaultURL)
                : Image.network(image[index]),
            title: Text(name[index]),
            subtitle: Text(description[index]),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(starRating[index]),
                Text(price[index]),
                Text(location[index]),
              ],
            ),
            onTap: () => Navigator.pushNamed(context, PRODUCTDETAIL,
                arguments: productRef[index]),
            onLongPress: () {
              _showDialog(context, index);
              print(cartList);
              print("index == $index");
            },
          );
        },
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
