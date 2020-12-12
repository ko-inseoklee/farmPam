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
String locDropdownValue = 'Location';
String farmLocDropdonwValue = 'Location';

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
          Center(
            child: DropdownButton<String>(
              value: locDropdownValue,
              icon: Icon(Icons.arrow_downward_outlined),
              iconSize: 20,
              underline: Container(
                height: 1,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                setState(() {
                  locDropdownValue = newValue;
                  addressToLocation addr = new addressToLocation(newValue);
                });
              },
              items: <String>['Location', '장량동', '환호동', '두호동', '흥해']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            //TODO: update lat,long when mark picked.
            width: 300,
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(36.0609, 129.3417),
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
              ? Center(
                  child: DropdownButton<String>(
                    value: farmLocDropdonwValue,
                    icon: Icon(Icons.arrow_downward_outlined),
                    iconSize: 20,
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        farmLocDropdonwValue = newValue;
                      });
                    },
                    items: <String>['Location', '장량동', '환호동', '두호동', '흥해']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
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
                      target: LatLng(36.0609, 129.3417),
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
                if (ModalRoute.of(context).settings.arguments == null) {
                  String userDoc = currentUser
                      .toString()
                      .substring(24, currentUser.toString().length - 1);
                  if (_isFarmer) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(userDoc)
                        .update({
                      "nickName": _nickName,
                      "address": locDropdownValue,
                      "addressLat": _userLat,
                      "addressLong": _userLong,
                      "isVerified": true,
                      "farmName": _farmName,
                      "farmLocation": farmLocDropdonwValue,
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
                      "address": locDropdownValue,
                      "addressLat": _userLat,
                      "addressLong": _userLong,
                      "isVerified": false,
                    });
                  }
                } else {
                  if (_isFarmer) {
                    await FirebaseFirestore.instance.collection("users").add({
                      "nickName": _nickName,
                      "address": locDropdownValue,
                      "addressLat": _userLat,
                      "addressLong": _userLong,
                      "isVerified": true,
                      "farmName": _farmName,
                      "farmLocation": farmLocDropdonwValue,
                      "farmDescription": _farmDescription,
                      "farmLocationLat": _farmLat,
                      "farmLocationLong": _farmLong,
                      'cart': [],
                      'chatList': [],
                      'favorite': [],
                      'like': [],
                      'sellingProducts': [],
                      'uid': user.uid,
                      'farmImage': '',
                      'farmReview': [],
                      'image': '',
                    });
                  } else {
                    await FirebaseFirestore.instance.collection("users").add({
                      "nickName": _nickName,
                      "address": locDropdownValue,
                      "addressLat": _userLat,
                      "addressLong": _userLong,
                      "isVerified": false,
                      'cart': [],
                      'chatList': [],
                      'favorite': [],
                      'like': [],
                      'isVerified': false,
                      'sellingProducts': [],
                      'uid': user.uid,
                      'farmDescription': '',
                      'farmImage': '',
                      'farmReview': [],
                      'farmName': '',
                      'farmLocation': '',
                      'farmLocationLat': 0,
                      'farmLocationLong': 0,
                      'image': '',
                    });
                  }
                }
                Navigator.pushNamed(context, HOME);
              },
              child: Text("Edit Profile"))
        ],
      ),
      bottomNavigationBar: footer(context),
    );
  }
}

class addressToLocation {
  String address;
  double latitude;
  double longitude;

  addressToLocation(String address) {
    if (address == "장량동") {
      this.latitude = 36.0702;
      this.longitude = 129.3789;
    } else if (address == "환호동") {
      this.latitude = 36.0707;
      this.longitude = 129.3971;
    } else if (address == "두호동") {
      this.latitude = 36.0609;
      this.longitude = 129.3800;
    } else {
      this.latitude = 36.1071;
      this.longitude = 129.3417;
    }
  }
}

//TODO: 이따 업데이트 때 넣었는지 체크할 내용들.
// if (_nickName == "") {
// print("_nickName is null");
// }

// LatLng.latitude 가능!
