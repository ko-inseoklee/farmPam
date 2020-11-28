import 'package:farmpam/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'assets.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            padding: EdgeInsets.only(top: 16.0),
            alignment: Alignment.center,
            child: SignInButton(Buttons.GoogleDark, text: "Google",
                onPressed: () async {
              _signInWithInGoogle();
            }),
          )),
    );
  }

  void _signInWithInGoogle() async {
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
      Navigator.pushNamed(context, HOME);
    } catch (e) {
      print(e);
    }
  }
}
