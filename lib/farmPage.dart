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

//
// import 'package:farmpam/productDetail.dart';
//
// import 'assets.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'signIn.dart';
// import 'farmPage.dart';
//
// Stream<DocumentSnapshot> cSnapshots = currentUser.snapshots();
//
// class profilePage extends StatefulWidget {
//   @override
//   _profilePageState createState() => _profilePageState();
// }
//
// class _profilePageState extends State<profilePage> {
//   String title = "Profile";
//   String address_ = '';
//   String nickName_ = '';
//
//   List<dynamic> sellingProducts_ = [];
//
//   DocumentReference userRef = currentUser;
//
//   void printf(DocumentReference docref) {
//     print(docref);
//   }
//
//   var imageReference;
//   @override
//   Widget build(BuildContext context) {
//     printf(userRef);
//
//     return StreamBuilder<DocumentSnapshot>(
//         stream: cSnapshots,
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> document) {
//           print("this is docu $document");
//           if (document.hasError) {
//             print("something wrong");
//           }
//           if (document.connectionState == ConnectionState.waiting) {
//             print("wait..");
//           }
//           // address_ = document.data['address'];
//           // nickName_ = document.data['nickName'];
//           // sellingProducts_ = document.data['sellingProducts'];
//           // imageReference = document.data['image'];
//
//           return Scaffold(
//             appBar: header(context, title, true),
//             body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   //TODO: 왼쪽 위에 이미지 나오게
//                   // FutureBuilder(
//                   //     future: imageReference.getDownloadURL(),
//                   //     builder: (context, snapshot) {
//                   //       if (!snapshot.hasData)
//                   //         return CircularProgressIndicator();
//                   //       return Image.network(snapshot.data);
//                   //       // return Text("test");
//                   //     }),
//                   /* Container(
//                 height: 70,
//                 width: 50,
//                 color: Colors.red,
//                 child: Text(
//                   'picture',
//                 )),*/
//                   //TODO: image옆에 닉네임, 장소
//                   Container(
//                       height: 70,
//                       width: 150,
//                       child: Column(
//                         children: <Widget>[
//                           Text(document.data['nickName']),
//                           Container(
//                             height: 1,
//                             width: 50,
//                             color: Colors.grey,
//                           ),
//                           Text(document.data['address']),
//                         ],
//                       ))
//                 ],
//               ),
//               Container(
//                 height: 1,
//                 color: Colors.grey,
//               ),
//               //TODO: FarmPage로 가는 버튼과 구매한 목록 이동 버튼 구현
//               Row(
//                 children: <Widget>[
//                   TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => farmPage()));
//                       },
//                       child: Text('goToFarmPage')),
//                   TextButton(
//                       onPressed: null, child: Text('goToBoughtProductsPage')),
//                 ],
//               ),
//               //TODO: 판매중인 목록
//             ]),
//             bottomNavigationBar: footer(context),
//           );
//         });
//   }
// }
