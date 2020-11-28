import 'dart:core';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

final SIGNIN = './signIn';
final SIGNUP = './signUp';
final HOME = './home';
final PROFILE = './profile';
final PRODUCTDETAIL = './productDetail';
final SETTINGS = './settings';
final ADDPRODUCT = './addProduct';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(farmPam());
}

class farmPam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmpam',
      home: signInPage(),
      initialRoute: SIGNIN,
      routes: {
        SIGNIN: (context) => signInPage(),
        //add other pages above.
      },
    );
  }
}
