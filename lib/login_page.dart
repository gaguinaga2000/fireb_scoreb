//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passObscure = true;
  Color _eyeColor = Colors.grey;

  String _snackBarMessage =
      "You entered an incorrect email, password, or both.";

  int _btnState = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//login Failure snackBar
  void _showSnackbar() {
    final SnackBar loginSnack = SnackBar(
      content: Text(_snackBarMessage,
          style: TextStyle(color: Colors.white, fontSize: 18.0)),
      backgroundColor: Colors.red[800],
    );
    _scaffoldKey.currentState.showSnackBar(loginSnack);
  } //END login Failure snackBar
//=================================================

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[850],
        body: Container(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 20.0, right: 20.0, left: 20.0),
            child: mainContent()),
      ),
    );
  } //END build Method
  //==============================

  //loginBtnChild
  Widget loginBtnChild() {
    if (_btnState == 0) {
      return Text("Login",
          style: TextStyle(color: Colors.white, fontSize: 20.0));
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  } //END loginBtnChild
//==========================================

//Sign in funtion
//Validates form and SignsIn with FirebaseAuth
  void signIn() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        //On succesful logIn, set _authStatus = AuthStatus.signedIn
        if (!user.isEmailVerified) {
          setState(() {
            _snackBarMessage =
                "Verify your Email: please check your email and click the link.";
            _btnState = 0;
            FirebaseAuth.instance.signOut();
          });
          _showSnackbar();
          return 0;
        } else {
          checkIfDocIsReal(user);
          widget.onSignedIn(user);
        }
      }).catchError((e) {
        print(e.message);
        setState(() {
          _btnState = 0;
        });
        _showSnackbar();
      });
    }
  } //END Sign in funtion
  //=========================================

//logo
  Widget displayLogo() {
    return Image.asset(
      "assets/logo_png5.png",
      scale: 2.1,
    );
  } // END logo
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
            loginButton(), //Login Button
            SizedBox(height: 5.0),
            forgotPassBtn(),
            SizedBox(height: 30.0),
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
          if (input.isEmpty) {
            setState(() {
              _btnState = 0;
            });
            return "Password field cannot be empty";
          }
        },
        onSaved: (input) => _password = input,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
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

//Reset button
  Widget loginButton() {
    return Container(
      height: 65.0,
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
      //  alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: invokeForgotPassPage,
        child: Text("Forgot password?",
            style: TextStyle(fontSize: 18.0, color: Colors.grey)),
      ),
    );
  } //END forgot pass btn
  //===============================

  //Not a member yet?
  Widget notMemberButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.white30),
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: FlatButton(
        onPressed: invokeSignupPage,
        child: Text(
          "Not a member? Sign up",
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  } //END Not a member yet?
//==========================================

  void invokeForgotPassPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ForgotPassword()));
  } //END
  //==========================================

//check if Doc is Real
  Future<void> checkIfDocIsReal(FirebaseUser user) async {
    Firestore.instance
        .collection("users")
        .document(user.uid)
        .get()
        .then((docSnapshot) => {
              if (docSnapshot.exists){
                  //do nothing
                }
              else {
                  setDisplayName(user), //creates document
                }
            });
  } //END

//==================================================
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

//-------------------------------------------------------
}
