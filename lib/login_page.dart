//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './signup_page.dart';
import './forgot_password.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedOut;

  final Function onSignedIn;

  const LoginPage({Key key, this.onSignedOut, this.onSignedIn})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;

  int _btnState = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //mainContent
  Widget mainContent() {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: displayLogo(),
          ),
          displayForm(),
        ],
      ),
    );
  } //END mainContent
  //=============================

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.grey[850],
        body: Padding(
          padding: const EdgeInsets.only(
              top: 60.0, bottom: 20.0, right: 20.0, left: 20.0),
          child: mainContent(),
        ),
      ),
    );
  } //END build Method
  //==============================

  //loginBtnChild
  Widget loginBtnChild() {
    if (_btnState == 0) {
      return Text("Login",
          style: TextStyle(color: Colors.white, fontSize: 19.0));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

//Sign in funtion
//Validates form and SignsIn with FirebaseAuth
  void signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //On succesful logIn, set _authStatus = AuthStatus.signedIn;
        widget.onSignedIn(user);
      } catch (e) {
        print(e);
      }
    }
  } //END Sign in funtion
  //=========================================

//logo
  Widget displayLogo() {
    return Image.asset(
      "assets/logo_png4.png",
      scale: 1.4,
    );
  } //enD logo
//================================

  Widget displayForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            emailField(),
            SizedBox(height: 15.0),
            passwordField(),
            forgotPassBtn(),
            SizedBox(height: 15.0),
            //Login Button
            loginButton(),
            notMemberButton(),
          ],
        ));
  } //END displayForm
  //===============================================

//Email Field
  Widget emailField() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 0.0, right: 10.0),
      height: 62.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return "Field cannot be empty";
          }
        },
        onSaved: (input) => _email = input,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email address",
            hintStyle: TextStyle(fontSize: 19.0, color: Colors.grey[800]),
            prefixIcon: Icon(Icons.email, color: Colors.grey[800])),
        obscureText: false,
      ),
    );
  } //END email field
//===================================================

//password Field
  Widget passwordField() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 0.0, right: 10.0),
      height: 62.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            return "Field cannot be empty";
          }
        },
        onSaved: (input) => _password = input,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 19.0, color: Colors.grey[800]),
            prefixIcon: Icon(Icons.lock, color: Colors.grey[800])),
        obscureText: true,
      ),
    );
  } //END password field
//===================================================

//Reset button
  Widget loginButton() {
    return Container(
      height: 70.0,
      width: 230.0,
      decoration: BoxDecoration(
        color: Color(0xFF21947e),
        border: Border.all(width: 0.0, color: Color(0xff0e5648)),
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          new BoxShadow(
            color: Color(0xff096251),
            offset: new Offset(0, 6.0),
          )
        ],
      ),
      child: FlatButton(
        onPressed: () {
          setState(() {
            _btnState = 1;
          });
          signIn();
        },
        child: loginBtnChild(),
      ),
    );
  } //END Reset button
  //===================================================

//invoke Signup Page
  void invokeSignupPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  } //END
//==================================

//Forgot pass button
  Widget forgotPassBtn() {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: invokeForgotPassPage,
        child: Text("forgot password?",
            style: TextStyle(fontSize: 18.0, color: Colors.grey)),
      ),
    );
  } //END forgot pass btn
  //===============================

  //Not a member yet?
  Widget notMemberButton() {
    return FlatButton(
      onPressed: invokeSignupPage,
      child: Text(
        "Not a member yet? Sign up!",
        style: TextStyle(fontSize: 18.0, color: Colors.grey),
      ),
    );
  } //END Not a member yet?
//==========================================

  void invokeForgotPassPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  }
//-------------------------------------------------------
}
