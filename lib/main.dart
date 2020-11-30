import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/addProduct.dart';
import 'package:farmpam/chatList.dart';
import 'package:farmpam/productDetail.dart';
import 'package:farmpam/profile.dart';
import 'package:farmpam/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'cart.dart';
import 'home.dart';
import 'signIn.dart';

final SIGNIN = './signIn';
final SIGNUP = './signUp';
final HOME = './home';
final PROFILE = './profile';
final PRODUCTDETAIL = './productDetail';
final SETTINGS = './settings';
final ADDPRODUCT = './addProduct';
final CHATLIST = './chatList';
final CART = './cart';

final defaultURL =
    "https://kubalubra.is/wp-content/uploads/2017/11/default-thumbnail.jpg";

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
        HOME: (context) => homePage(),
        ADDPRODUCT: (context) => addProductPage(),
        SETTINGS: (context) => settingPage(),
        PROFILE: (context) => profilePage(),
        //add other pages above.
        CHATLIST: (context) => chatListPage(),
        CART: (context) => cartPage(),
        PRODUCTDETAIL: (context) => productDetailPage()
      },
    );
  }
}
