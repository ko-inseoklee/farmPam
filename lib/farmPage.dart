import 'assets.dart';
import 'package:flutter/material.dart';
import 'signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class farmPage extends StatefulWidget {
  @override
  _farmPageState createState() => _farmPageState();
}

class _farmPageState extends State<farmPage> {
  //Todo: title will be friend name.
  String title = "Farm";
  var imageReference;

  String farmName_;
  String farmImage_;
  String farmDescription_;
  String farmLocation_;
  List<dynamic> farmReview_;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: currentUser.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> document) {
          if (document.hasError) {
            print("something wrong");
          }
          if (document.connectionState == ConnectionState.waiting) {
            print("wait..");
          }
          farmName_ = document.data['farmName'];
          farmImage_ = document.data['farmImage'];
          farmDescription_ = document.data['farmDescription'];
          imageReference = document.data['farmImage'];
          farmLocation_ = document.data['farmLocation'];

          return Scaffold(
            appBar: header(context, title, true),
            body: ListView(
              children: <Widget>[
                // FutureBuilder(
                //     future: imageReference.getDownloadURL(),
                //     builder: (context, snapshot) {
                //       if (!snapshot.hasData) return CircularProgressIndicator();
                //       return Image.network(snapshot.data);
                //     }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(document.data['farmName']),
                    SizedBox(
                      width: 20,
                    ),
                    Text(farmLocation_),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                Text(farmDescription_),
              ],
            ),
            bottomNavigationBar: footer(context),
          );
        });
  }
}
