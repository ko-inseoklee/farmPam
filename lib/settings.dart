import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/profile.dart';
import 'package:farmpam/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _settingPageState extends State<settingPage> {
  String title = "Settings";
  String userDoc;

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Account Register?"),
            actions: [
              FlatButton(
                  onPressed: () {
                    deleteUser();
                  },
                  child: Text("Unregister")),
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"))
            ],
          );
        });
  }

  Future<void> deleteUser() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userDoc)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"))
        .then((value) {
      print("Unregistered Successfully.");
      currentUser = null;
      Navigator.pushNamed(context, SIGNIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    userDoc =
        currentUser.toString().substring(24, currentUser.toString().length - 1);

    print("setting : $userDoc");

    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(
        shrinkWrap: true,
        children: [
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Profile"),
            onTap: () {
              //TODO: navigate to edit Profile page.
              Navigator.pushNamed(context, PROFILE);
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Edit Profile"),
            onTap: () {
              //TODO: navigate to edit Profile page.
              Navigator.pushNamed(context, EDITPROFILE);
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Sign Out"),
            onTap: () {
              //TODO: sign-out and navigate to sign-in page.
              void _signOut() async {
                await _auth.signOut();
              }

              _signOut();
              Navigator.pushNamed(context, SIGNIN);
            },
          ),
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Unregister Account"),
            onTap: () {
              //TODO: Show dialog
              _showDialog();

              //TODO: Delete on the database

              //TODO: Delete user

              //TODO: Sign out
              // void _signOut() async {
              //   await _auth.signOut();
              // }

              // _signOut();
              //TODO: Navigate to signin page.
              // Navigator.pushNamed(context, SIGNIN);
            },
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
