import 'dart:io';

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

FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                  height: 350,
                  width: 300,
                  child: Column(
                    children: [
                      Image.asset('assets/farmer.png',
                          width: 125, height: 250, fit: BoxFit.fill),
                      Text(
                        "팜팜",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      Text(
                        "농가와 시민의 직거래 어플리케이션",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                      )
                    ],
                  )),
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
          elevation: 20,
          color: Colors.deepOrange,
          shadowColor: Colors.deepOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                  padding: EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "로그인하고 나만의 농장을 찾아보세요",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      //SizedBox(height: 120),
                      SignInButton(Buttons.Google, text: "Sign in with Google",
                          onPressed: () async {
                        await _signInWithInGoogle(snapshot);
                      }),
                    ],
                  ))),
        );
      },
    );
  }

  Future<void> _signInWithInGoogle(
      AsyncSnapshot<QuerySnapshot> snapshot) async {
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

      bool inID = false;

      await FirebaseFirestore.instance
          .collection("users")
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.length != 0) {
          inID = true;
        } else {
          currentUser = value.docs[0].reference;
        }
      });

      if (!inID) {
        Navigator.pushNamed(context, EDITPROFILE, arguments: false);
      } else {
        Navigator.pushNamed(context, HOME);
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: ${e}"),
      ));
    }
  }
}
