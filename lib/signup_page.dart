import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_page.dart';
import './main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passObscure = true;
  Color _eyeColor = Colors.grey;
  int _btnState = 0;

  String _errorMessage = '';

  void _showSnackbar() {
    final SnackBar signUpFailSnack = SnackBar(
      content: Row(children: [
        Expanded(
          flex: 10,
          child: Text(_errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 18.0)),
        ),
        Expanded(flex: 0, child: Icon(Icons.error))
      ]),
      backgroundColor: Colors.red[800],
    );
    _scaffoldKey.currentState.showSnackBar(signUpFailSnack);
  }

  //mainContent
  Widget mainContent() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: displayLogo,
        ),
        displayForm(),
      ],
    );
  } //END mainContent

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        body: Container(
            decoration: BoxDecoration(),
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 20.0, right: 20.0, left: 20.0),
            child: mainContent()),
      ),
    );
  }

  //loginBtnChild
  Widget signUpBtnChild() {
    if (_btnState == 0) {
      return Text("Create account",
          style: TextStyle(color: Colors.white, fontSize: 20.0));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  } //END loginBtnChild
//==========================================

  //logo
  final Image displayLogo = Image.asset(
    "assets/logo_png5.png",
    scale: 2.1,
  );
  // END logo
//================================

  Widget displayForm() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            emailField(),
            SizedBox(height: 15.0),
            passwordField(),
            SizedBox(height: 23.0),
            //Signup Button
            signUpButton(),
            SizedBox(height: 5.0),
            hasAccountButton(),
          ],
        ));
  } //END displayForm
  //===============================================

//Email Field
  Widget emailField() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 0.0, right: 10.0),
      height: 65.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: TextFormField(
        validator: (input) {
          if (input.isEmpty) {
            setState(() {
              _btnState = 0;
            });
            return "Email field cannot be empty";
          }
        },
        onSaved: (input) => _email = input,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email address",
            hintStyle: TextStyle(fontSize: 19.0, color: Colors.grey[700]),
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
      height: 65.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: TextFormField(
        validator: (input) {
          if (input.length < 6) {
            setState(() {
              _btnState = 0;
            });
            return "Password must contain at least 6 characters.";
          }
        },
        onSaved: (input) => _password = input,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Choose a password",
          hintStyle: TextStyle(fontSize: 19.0, color: Colors.grey[700]),
          prefixIcon: Icon(Icons.lock, color: Colors.grey[800]),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye, color: _eyeColor),
            tooltip: 'Show password',
            onPressed: () {
              setState(() {
                if (_passObscure) {
                  _passObscure = false;
                  _eyeColor = Colors.cyan[800];
                } else {
                  _passObscure = true;
                  _eyeColor = Colors.grey;
                }
              });
            },
          ),
        ),
        obscureText: _passObscure,
      ),
    );
  } //END password field
//===================================================

//Container for bgImage
  Container bgContainer = Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        alignment: FractionalOffset.center,
        image: AssetImage(""),
        fit: BoxFit.cover,
      ),
    ),
  );
  //END for Container

//Reset button
  Widget signUpButton() {
    return Container(
      height: 70.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF21947e),
        border: Border.all(width: 0.0, color: Color(0xff0e5648)),
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          new BoxShadow(
            color: Color(0xff096251),
            offset: new Offset(0, 4.0),
          )
        ],
      ),
      child: FlatButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _btnState = 1;
          });
          signUp();
        },
        child: signUpBtnChild(),
      ),
    );
  } //END Reset button
  //===================================================

//Signup request
  void signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        user.sendEmailVerification();
        setDisplayName(user);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (cntext) => LoginPage()));
      }).catchError((e) {
        setState(() {
          _btnState = 0;
          _errorMessage = e.message;
        });
        _showSnackbar();
      });
    }
  }

//sets email as "displayname"
  void setDisplayName(FirebaseUser user) {
    DocumentReference docRef =
        Firestore.instance.collection("users").document(user.uid);

    Map<String, dynamic> updateProfile = {
      "display_name": user.email,
      "email": user.email,
      "age": "",
      "favorite_quote": "",
    };

    docRef.setData(updateProfile).whenComplete(() {
      print("profile updated");
    });
  } //END

  //=========================================
  //Not a member yet?
  Widget hasAccountButton() {
    return FlatButton(
      onPressed: invokeLoginPage,
      child: Text(
        "Have an account? Sign in",
        style: TextStyle(fontSize: 18.0, color: Colors.grey),
      ),
    );
  } //END Not a member yet?

//==========================================
  void invokeLoginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  } //END

  //----------------
}
