import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/main.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final editNickName = TextEditingController();
final editFarmName = TextEditingController();
final editFarmDescription = TextEditingController();

String _nickName = '';
double _userLat;
double _userLong;
bool _isFarmer = false;
String _farmName = '';
String _farmDescription = '';
double _farmLat;
double _farmLong;

class editProfilePage extends StatefulWidget {
  @override
  _editProfilePageState createState() => _editProfilePageState();
}

class _editProfilePageState extends State<editProfilePage> {
  String title = 'Edit profile';

  Completer<GoogleMapController> _mapController = Completer();

  Map<String, Marker> _markers = {};
  Map<String, Marker> _farmMarkers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: editNickName,
                decoration: InputDecoration(
                  hintText: "- Nickname",
                ),
                onChanged: (String value) {
                  _nickName = value;
                  print(_nickName);
                },
              )),
          Divider(
            thickness: 0.5,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text("- Set Location"),
          ),
          SizedBox(
            //TODO: update lat,long when mark picked.
            width: 300,
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.52, 126.92),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {},
              markers: _markers.values.toSet(),
              onTap: (marker) {
                setState(() {
                  _userLat = marker.latitude;
                  _userLong = marker.longitude;
                  final userLocation = Marker(
                      markerId: MarkerId("userLocation"), position: marker);
                  _markers.clear();
                  _markers["current"] = userLocation;
                });
              },
            ),
          ),
          Divider(
            thickness: 0.5,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(16.0),
                child: Text("- Are you Farmer?"),
              )),
              Switch(
                  value: _isFarmer,
                  onChanged: (bool newValue) {
                    setState(() {
                      _isFarmer = !_isFarmer;
                      // print(_isFarmer);
                    });
                  })
            ],
          ),
          _isFarmer
              ? Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: editFarmName,
                    decoration: InputDecoration(
                      hintText: "- Farm Name",
                    ),
                    onChanged: (String value) {
                      _farmName = value;
                    },
                  ))
              : Container(
                  child: Text(""),
                ),
          _isFarmer
              ? Container(
                  padding: EdgeInsets.all(16.0),
                  child: TextField(
                    controller: editFarmDescription,
                    decoration: InputDecoration(
                      hintText: "- Farm Description",
                    ),
                    onChanged: (String value) {
                      _farmDescription = value;
                    },
                  ))
              : Container(
                  child: Text(""),
                ),
          _isFarmer
              ? Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text("- Set Farmer Location"),
                )
              : Container(
                  child: Text(""),
                ),
          _isFarmer
              ? SizedBox(
                  //TODO: update lat,long when mark picked.
                  width: 300,
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(37.52, 126.92),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
                    markers: _farmMarkers.values.toSet(),
                    onTap: (marker) {
                      setState(() {
                        _farmLat = marker.latitude;
                        _farmLong = marker.longitude;
                        final farmerLocation = Marker(
                            markerId: MarkerId("FarmLocation"),
                            position: marker);
                        _farmMarkers.clear();
                        _farmMarkers["current"] = farmerLocation;
                      });
                    },
                  ),
                )
              : Container(
                  child: Text(""),
                ),
          Divider(),
          FlatButton(
              onPressed: () async {
                String userDoc = currentUser
                    .toString()
                    .substring(24, currentUser.toString().length - 1);

                if (_isFarmer) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userDoc)
                      .update({
                    "nickName": _nickName,
                    "addressLat": _userLat,
                    "addressLong": _userLong,
                    "isVerified": true,
                    "farmName": _farmName,
                    "farmDescription": _farmDescription,
                    "farmLocationLat": _farmLat,
                    "farmLocationLong": _farmLong
                  });
                } else {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(userDoc)
                      .update({
                    "nickName": _nickName,
                    "addressLat": _userLat,
                    "addressLong": _userLong,
                    "isVerified": false,
                  });
                }
                Navigator.pushNamed(context, SETTINGS);
              },
              child: Text("Edit Profile"))
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}

//TODO: 이따 업데이트 때 넣었는지 체크할 내용들.
// if (_nickName == "") {
// print("_nickName is null");
// }

// LatLng.latitude 가능!
