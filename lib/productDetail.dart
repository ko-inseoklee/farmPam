import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';

import 'main.dart';

bool isCreater;

FirebaseFirestore firestore = FirebaseFirestore.instance;

String creator = '';
String cUser = '';

class productDetailPage extends StatefulWidget {
  @override
  _productDetailPageState createState() => _productDetailPageState();
}

class _productDetailPageState extends State<productDetailPage> {
  String title = 'Product Detail';

  @override
  Widget build(BuildContext context) {
    DocumentReference docRef = ModalRoute.of(context).settings.arguments;

    String productDocument =
        docRef.toString().substring(26, docRef.toString().length - 1);
    print("docref = $docRef");

    firestore
        .collection("product")
        .doc(productDocument)
        .get()
        .then((DocumentSnapshot snapshot) async {
      creator = await snapshot.data()['creatorID'];
    });

    print("Creator == $creator");

    String userDocument =
        currentUser.toString().substring(23, currentUser.toString().length - 1);

    firestore
        .collection("users")
        .doc(userDocument)
        .get()
        .then((DocumentSnapshot snapshot) async {
      cUser = await snapshot.data()['uid'];
    });

    // print("Creator == $creator , cUser == $cUser");

    if (creator.compareTo(cUser) == 0) {
      isCreater = true;
    } else {
      isCreater = false;
    }

    return Scaffold(
      appBar: header(context, title, isCreater),
      body: StreamBuilder<DocumentSnapshot>(
        stream: docRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> document) {
          if (document.hasError) {
            return Text("Something wrong");
          }
          if (document.connectionState == ConnectionState.waiting) {
            return Text("Waiting");
          }

          String _name = document.data['name'];
          String _starRating = document.data['starRating'].toString();
          String _price = document.data['price'].toString();
          String _productID = document.data['ID'];

          return ListView(
            children: [
              Stack(
                alignment: const Alignment(0.95, -0.9),
                children: [
                  Image.network(true ? defaultURL : document.data['image']),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.add_shopping_cart),
                            onPressed: () async {
                              //TODO: already has? show SnackBar(already stored.) : update user document, show SnackBar(product stored.)
                              String message = "good";
                              String cUser = currentUser.toString().substring(
                                  24, currentUser.toString().length - 1);
                              print(cUser);
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(cUser)
                                  .get()
                                  .then((DocumentSnapshot document) async {
                                List<dynamic> cartList =
                                    document.data()["cart"];
                                if (cartList.contains(_productID)) {
                                  message = 'Already exists!';
                                } else {
                                  cartList.add(_productID);
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(cUser)
                                      .update({'cart': cartList});
                                  message = 'Successfully add in your cart!';
                                }
                              });
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(message),
                              ));
                            })
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(_name),
                      ],
                    ),
                    Column(
                      children: [Text(_starRating), Text('₩$_price')],
                    )
                  ],
                ),
              ),
              Divider(),
              //TODO: Location will be displayed by API.
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text("there will be location"),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text(document.data['description']),
              ),
              Divider(),
              Container(
                child: FlatButton(
                  child: Text("Write Review"),
                  onPressed: () {
                    //TODO: Make a dialog window for writing review and starRating.
                    print("good");
                  },
                ),
              ),
              //TODO: put the List of Reviews.
            ],
          );
        },
      ),
      bottomNavigationBar: footer(context),
    );
  }
}

//TODO: review를 쓸때 별점도 같이 쓸 수 있게 해야함. add starRatingList field.
