import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _emailControl = TextEditingController();
  String _email;

  String _snackMessage =
      "Please check your email to reset your password. Thank you.";

  Color _snackBgColor = Color(0xFF10816b);

//SnackBar function
  void _showSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        _snackMessage,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
      backgroundColor: _snackBgColor,
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  } //END SnackBar function
  //============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      body: mainContent(),
    );
  }

  Widget mainContent() {
    return Container(
        padding: const EdgeInsets.only(
            top: 70.0, bottom: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text("Forgot your password?",
                  style: TextStyle(color: Colors.white, fontSize: 30.0)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 30.0),
              child: Center(
                child: Text("We'll help you get back in.",
                    style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
            ),
            //Enter your email address
            Text(
              "Email address: ",
              style: TextStyle(color: Color(0xff27ecc9), fontSize: 17.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: emailField(),
            ),

            Center(child: resetPasswordBtn()),
            
            Center(child: backButton()),
          ],
        ));
  }

//Back button
  Widget backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Back", style: TextStyle(fontSize: 21.0, color: Colors.white30))),
    );
  } //END Back button
  //=================================================

  Widget emailField() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 20.0, right: 10.0),
      height: 60.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        color: Colors.white,
      ),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 18.0),
        controller: _emailControl,
        onChanged: (String value) {
          _email = value;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

//Reset button
  Widget resetPasswordBtn() {
    return Container(
      height: 70.0,
      width: 230.0,
      decoration: BoxDecoration(
        color: Color(0xFF21947e),
        border: Border.all(width: 0.0, color: Color(0xff0e5648)),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: FlatButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          checkIfEmailExists().then((QuerySnapshot docs) {
            if (docs.documents.isNotEmpty && _email != "") {
              setState(() {
                _snackMessage =
                    "Please check your email to reset your password. Thank you.";
                _snackBgColor = Color(0xFF10816b);
              });
              _showSnackBar();
              print("found");
              // sendPasswordResetEmail(_email);
            } else {
              setState(() {
                _snackBgColor = Colors.red[700];
                _snackMessage =
                    "Email does not exist. Please enter a valid email address.";
              });
              _showSnackBar();
              print("email does not exist");
            }
          });
        },
        child: Text("Reset password",
            style: TextStyle(color: Colors.white, fontSize: 19.0)),
      ),
    );
  } //END Reset button
  //===================================================

//check if user email exists
  Future<QuerySnapshot> checkIfEmailExists() async {
    return Firestore.instance
        .collection("users")
        .where('email', isEqualTo: _email)
        .getDocuments();
  } //END check if email is real
  //==================================================

//Firebase default reset email function
  Future<void> sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
  //---------------------------------------------------
}
