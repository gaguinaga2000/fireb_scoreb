import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _emailControl = TextEditingController();
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Color(0xffa01819),
        // title: Text("Reset"),
        //  centerTitle: true,
      ),
      body: mainContent(),
    );
  }

  Widget mainContent() {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text("Forgot your password?",
                  style: TextStyle(color: Colors.white, fontSize: 30.0)),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 30.0),
              child: Center(
                child: Text("We'll help you get it back.",
                    style: TextStyle(color: Colors.white, fontSize: 20.0)),
              ),
            ),
            //Enter your email address
            Text(
              "Email address: ",
              style: TextStyle(color: Color(0xff1b9981), fontSize: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: emailField(),
            ),
            Center(child: resetPasswordBtn()),
            //Reset btun
          ],
        ));
  }

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
         // sendPasswordResetEmail(_email);
        },
        child: Text("Reset password",
            style: TextStyle(color: Colors.white, fontSize: 18.0)),
      ),
    );
  } //END Reset button
  //===================================================

  Future<void> sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
  //---------------------------------------------------
}
