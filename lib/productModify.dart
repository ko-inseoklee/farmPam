import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmpam/assets.dart';
import 'package:farmpam/signIn.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'main.dart';

class productModifyPage extends StatefulWidget {
  @override
  DocumentReference _docRef;
  productModifyPage(DocumentReference docRef) {
    _docRef = docRef;
  }
  _productModifyPageState createState() => _productModifyPageState(_docRef);
}

class _productModifyPageState extends State<productModifyPage> {
  final databaseReference = FirebaseFirestore.instance;

  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productDescription = TextEditingController();
  var newImageUploaded = false;
  var _image;
  var _image2;
  String dropdownValue = 'Category';
  String _productID;

  Widget imageDisplay() {
    if (!newImageUploaded) {
      return Image.network(_image, width: 200, height: 150);
    } else {
      return Image.file(_image2, width: 200, height: 150);
    }
  }

  void modifyProduct(String name, String price, String description) async {
    await _docRef.update({
      'name': name,
      'price': int.parse(price),
      'image': "images/${_productID}",
      'description': description,
      'lastModified': FieldValue.serverTimestamp(),
    });
  }

  Future uploadFile(String productName) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('product/${_productID}');
    StorageUploadTask uploadTask = storageReference.putFile(_image2);
    await uploadTask.onComplete;
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {});
    });
  }

  Future getImage() async {
    final _picker = ImagePicker();
    var imageTemp = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image2 = File(imageTemp.path);
      newImageUploaded = true; // Need?
    });
  }

  DocumentReference _docRef;
  _productModifyPageState(DocumentReference docRef) {
    _docRef = docRef;
  }

  String title = "Product Modify";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, title, true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _docRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> document) {
          if (document.hasError) {
            return Text("Something wrong");
          }
          if (document.connectionState == ConnectionState.waiting) {
            return Text("Waiting");
          }
          String _name = document.data['name'];
          String _price = document.data['price'].toString();
          String _description = document.data['description'];
          _productID = document.data['ID'];
          _image = document.data['image'];

          return ListView(children: <Widget>[
            imageDisplay(),
            SizedBox(
              height: 2,
            ),
            IconButton(
              icon: Icon(
                Icons.camera_alt,
              ),
              onPressed: () {
                getImage();
              },
            ),
            Center(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward_outlined),
                iconSize: 20,
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Category', '과일', '채소', '견과류', '곡물']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            TextFormField(
              controller: productName,
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: _name,
              ),
            ),
            TextFormField(
              controller: productPrice,
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: _price.toString(),
              ),
            ),
            TextFormField(
              controller: productDescription,
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                labelText: _description,
              ),
            ),
            FlatButton(
              onPressed: () {
                modifyProduct(productName.text, productPrice.text,
                    productDescription.text);
                uploadFile(productName.text);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ]);
        },
      ),
      bottomNavigationBar: footer(context),
    );
  }
}
