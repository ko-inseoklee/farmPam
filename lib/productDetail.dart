import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';

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
    // print("docref = $document");

    firestore
        .collection("product")
        .doc(productDocument)
        .get()
        .then((DocumentSnapshot snapshot) async {
      creator = await snapshot.data()['creatorID'];
    });

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
          return Container(
            child: Text(document.data['name']),
          );
        },
      ),
      bottomNavigationBar: footer(context),
    );
  }
}

//TODO: review를 쓸때 별점도 같이 쓸 수 있게 해야함. add starRatingList field.
