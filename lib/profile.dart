import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/settings.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

String _userName = "";
double _userLat = 0;
double _userLong = 0;

class _profilePageState extends State<profilePage> {
  //Todo: title will be friend name.
  String title = "Profile";
  String userDoc =
      currentUser.toString().substring(24, currentUser.toString().length - 1);

  Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    setState(() {
      _userName = userName;
      _userLat = userLat;
      _userLong = userLong;
      final _userLocation = Marker(
          markerId: MarkerId("FarmLocation"), position: LatLng(5.0, 5.0));
      _markers.clear();
      _markers["current"] = _userLocation;
    });

    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                child: Text("NickName : $_userName"),
              ),
              Container(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, EDITPROFILE),
                      child: Text("Edit Profile")))
            ],
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_userLat, _userLong),
                zoom: 13,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
              padding: EdgeInsets.all(16.0),
              child: FlatButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, FARMPAGE),
                  child: Text("Farm Page")))

        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
