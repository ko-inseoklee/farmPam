import 'package:farmpam/productDetail.dart';

import 'assets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'signIn.dart';
import 'farmPage.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String title = "Profile";
  String address_ = '';
  String nickName_ = '';

  List<dynamic> sellingProducts_ = [];

  DocumentReference userRef = currentUser;

  void printf(DocumentReference docref) {
    print(docref);
  }

  var imageReference;
  @override
  Widget build(BuildContext context) {
    printf(userRef);

    return StreamBuilder<DocumentSnapshot>(
        stream: currentUser.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> document) {
          print("this is docu $document");
          if (document.hasError) {
            print("something wrong");
          }
          if (document.connectionState == ConnectionState.waiting) {
            print("wait..");
          }
          address_ = document.data['address'];
          nickName_ = document.data['nickName'];
          sellingProducts_ = document.data['sellingProducts'];
          imageReference = document.data['image'];

          return Scaffold(
            appBar: header(context, title, true),
            body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
              Row(
                children: <Widget>[
                  //TODO: 왼쪽 위에 이미지 나오게
                  // FutureBuilder(
                  //     future: imageReference.getDownloadURL(),
                  //     builder: (context, snapshot) {
                  //       if (!snapshot.hasData)
                  //         return CircularProgressIndicator();
                  //       return Image.network(snapshot.data);
                  //       // return Text("test");
                  //     }),
                  /* Container(
                height: 70,
                width: 50,
                color: Colors.red,
                child: Text(
                  'picture',
                )),*/
                  //TODO: image옆에 닉네임, 장소
                  Container(
                      height: 70,
                      width: 150,
                      child: Column(
                        children: <Widget>[
                          Text(nickName_),
                          Container(
                            height: 1,
                            width: 50,
                            color: Colors.grey,
                          ),
                          Text(address_),
                        ],
                      ))
                ],
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              //TODO: FarmPage로 가는 버튼과 구매한 목록 이동 버튼 구현
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => farmPage()));
                      },
                      child: Text('goToFarmPage')),
                  TextButton(
                      onPressed: null, child: Text('goToBoughtProductsPage')),
                ],
              ),
              //TODO: 판매중인 목록
            ]),
            bottomNavigationBar: footer(context),
          );
        });
  }
}
