import 'dart:async';
import './logout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final FirebaseUser user;
  final VoidCallback onSignedOut;

  const ProfilePage({Key key, this.user, this.onSignedOut}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String displayName, favQuote;
  int userAge;

  int _btnState = 0;

  bool infoLoaded = false;

  static String preName, preQuote;
  int preAge;

  TextEditingController _displayNameControl;
  TextEditingController _ageControl;
  TextEditingController _quoteControl;

  @override
  void initState() {
    prePopulate().then((doc) {
      setState(() {
        _displayNameControl = TextEditingController(text: doc['display_name']);
        _ageControl = TextEditingController(text: doc['age']);
        _quoteControl = TextEditingController(text: doc['favorite_quote']);
        infoLoaded = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text("Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: infoLoaded == true
            ? mainContent()
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  //************************************************
//Progress button stuff
  Widget animatedBtn() {
    if (_btnState == 0) {
      return Text(
        "UPDATE",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
    } else if (_btnState == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }
//==================================================

  Widget mainContent() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            // keyboardType: TextInputType.text,
            controller: _displayNameControl,
            style: TextStyle(fontSize: 18.0),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              suffixIcon: Icon(Icons.create),
              labelText: "Display name",
              labelStyle: TextStyle(fontSize: 18.0),
            ),
            onChanged: (String value) {
              setState(() {
                _btnState = 0;
              });
            },
          ),
          TextField(
            controller: _ageControl,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              suffixIcon: Icon(Icons.create),
              labelText: "Age",
              labelStyle: TextStyle(fontSize: 18.0),
            ),
            onChanged: (String value) {
              setState(() {
                _btnState = 0;
              });
            },
          ),
          TextField(
            //  keyboardType: TextInputType.text,
            controller: _quoteControl,
            decoration: InputDecoration(
                alignLabelWithHint: true,
                suffixIcon: Icon(Icons.create),
                labelStyle: TextStyle(fontSize: 18.0),
                labelText: "Favorite quote"),
            onChanged: (String value) {
              setState(() {
                _btnState = 0;
              });
            },
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            child: FlatButton(
              color: Colors.blue[800],
              child: animatedBtn(),
              onPressed: updateProfile,
            ),
          ),
          LogOutButton(onSignedOut: widget.onSignedOut),
        ],
      ),
    );
  } //END mainContent
  //=========================================

  void updateProfile() {
    setState(() {
      _btnState = 1;
    });
    DocumentReference docRef =
        Firestore.instance.collection('users').document(widget.user.uid);

    Map<String, dynamic> userInfo = {
      "display_name": _displayNameControl.text,
      "favorite_quote": _quoteControl.text,
      "age": _ageControl.text.toString(),
    };

    docRef.setData(userInfo).whenComplete(() {
      setState(() {
        _btnState = 2;
        FocusScope.of(context).requestFocus(FocusNode());
      });
      print("user info updated");
    });
  }

//returns a snapshot of UserProfile
  Future<DocumentSnapshot> prePopulate() async {
    var document =
        Firestore.instance.collection("users").document(widget.user.uid).get();

    return await document;
  } //END

//=========================================================
}
