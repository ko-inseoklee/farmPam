import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class profilePage extends StatefulWidget {
  @override
  _profilePageState createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  //Todo: title will be friend name.
  String title = "Profile";

  Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    setState(() {
      final _userLocation = Marker(
          markerId: MarkerId("FarmLocation"), position: LatLng(5.0, 5.0));
      _markers.clear();
      _markers["current"] = _userLocation;
    });

    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text("test"),
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(5, 5),
                zoom: 13,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
