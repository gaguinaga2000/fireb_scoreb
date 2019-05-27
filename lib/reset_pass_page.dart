import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPage extends StatefulWidget {
  final FirebaseUser user;
  final VoidCallback onSignedOut;

  const ResetPage({Key key, this.user, this.onSignedOut}) : super(key: key);

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  String displayName, favQuote;
  int userAge;


  int _resetBtnState = 0;

  bool infoLoaded = false;

  static String preName, preQuote;
  int preAge;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.red[800],
        title: Text("Reset password..."),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: mainContent(),
      ),
    );
  }

  //************************************************
//Progress button stuff
  Widget animatedBtn(String btnText) {
    if (_resetBtnState == 0) {
      return Text(
        btnText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
    } else if (_resetBtnState == 1) {
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
          Text(
            "Resetting password for: ${widget.user.email}",
            style: TextStyle(fontSize: 18.0),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 15.0),
            height: 60.0,
            child: resetBtn(),
          ),
          // LogOutButton(onSignedOut: widget.onSignedOut),
        ],
      ),
    );
  } //END mainContent
  //=========================================

//Reset Button
  Widget resetBtn() {
    return FlatButton(
        color: Colors.blue[800],
        child: animatedBtn("RESET"),
        onPressed: () {
          // sendPasswordResetEmail(widget.user.email);
          resetBtnPressed();
        });
  }
//=================================

  Future<void> sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

//returns a snapshot of UserProfile
  Future<DocumentSnapshot> prePopulate() async {
    var document =
        Firestore.instance.collection("users").document(widget.user.uid).get();

    return await document;
  } //END

//sets btnStates when reset button is pressed
  void resetBtnPressed() {
    setState(() {
      _resetBtnState = 1;
    });

    Timer(Duration(milliseconds: 700), () {
      setState(() {
        _resetBtnState = 2;
      });
      _showDialog();
    });
  } //END
  //================================================

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("One more step..."),
          content: Text("Please check your email to choose a new password.\n\nThank you for using iSkorez!",
              style: TextStyle(fontSize: 18.0)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("CLOSE",
                  style: TextStyle(fontSize: 19.0, color: Colors.blue[800])),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

//=========================================================
}
