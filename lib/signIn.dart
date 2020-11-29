import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'assets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

DocumentReference currentUser;
bool containsID = false;
User user = _auth.currentUser;

class signInPage extends StatefulWidget {
  @override
  _signInPageState createState() => _signInPageState();
}

class _signInPageState extends State<signInPage> {
  // title will be title on the appbar of the page.
  String title = 'Sign In';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        //TODO: Decorate this page.
        return Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //Todo: Insert icon into this container
              Container(
                alignment: Alignment.center,
                child: Text("Icon"),
              ),
              _signInWithGoogle(),
            ],
          ),
        );
      }),
    );
  }
}

class _signInWithGoogle extends StatefulWidget {
  @override
  __signInWithGoogleState createState() => __signInWithGoogleState();
}

class __signInWithGoogleState extends State<_signInWithGoogle> {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print("something wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("wait..");
        }

        return Card(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: SignInButton(Buttons.GoogleDark, text: "Google",
                    onPressed: () async {
                  _signInWithInGoogle(snapshot);
                }),
              )),
        );
      },
    );
  }

  void _signInWithInGoogle(AsyncSnapshot<QuerySnapshot> snapshot) async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final GoogleAuthCredential googleAuthCredential =
            GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }
      final user = userCredential.user;

      await configuration(snapshot);
      Navigator.pushNamed(context, HOME);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e}"),
      ));
    }
  }

  Future<void> configuration(AsyncSnapshot<QuerySnapshot> snapshot) async {
    snapshot.data.docs.map((DocumentSnapshot document) async {
      String temp = await document.data()['uid'];
      if (temp == user.uid) {
        currentUser = document.reference;
        containsID = true;
      }
    }).toList();

    if (!containsID) {
      await users.add({
        'address': "",
        'cart': "",
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
    print("signin=$currentUser");
  }
}
