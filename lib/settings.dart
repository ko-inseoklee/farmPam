import 'package:farmpam/assets.dart';
import 'package:farmpam/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _settingPageState extends State<settingPage> {
  String title = "Settings";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(
        shrinkWrap: true,
        children: [
          Divider(
            thickness: 2,
          ),
          ListTile(
            title: Text("Edit Profile"),
            onTap: () {
              //TODO: navigate to edit Profile page.
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
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
