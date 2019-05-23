import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './main.dart';

class LogOutButton extends StatefulWidget {
  final VoidCallback onSignedOut;

  const LogOutButton({Key key, this.onSignedOut}) : super(key: key);

  @override
  _LogOutButtonState createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  @override
  Widget build(BuildContext context) {
    return logOutBtn();
  }

//logOutButton
  Widget logOutBtn() {
    return FlatButton(
      color: Colors.red,
      child: Text("Log out"),
      onPressed: _signOut,
    );
  } //END
//========================

//signout function
  void _signOut() async {
    try {
      await signOut();
      widget.onSignedOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    } catch (e) {
      print(e);
    }
  } //END signout function
//====================================

//Firebase signout
  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  } //END
//===============================================

}
