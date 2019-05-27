import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './login_page.dart';
import './add_counter_page.dart';
import 'package:flutter/services.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _MyAppState extends State<MyApp> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  FirebaseUser user;

  void _signedIn(FirebaseUser loggedInUser) {
    setState(() {
      _authStatus = AuthStatus.signedIn;
      user = loggedInUser;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  void initState() {
    currentUser().then((userId) {
      setState(() {
        _authStatus =
            userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    //   print("id " + userId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyCounters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: determineHomePage(),
      ),
    );
  }

//determines if user is loggedIn or not
  Widget determineHomePage() {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            child: LoginPage(onSignedIn: _signedIn, onSignedOut: _signedOut));
      default:
        return AddCounterPage(
            title: 'Add Counter', user: user, onSignedOut: _signedOut);
    }
  } //END
//=====================================

//return string user.uid
  Future<String> currentUser() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;

    return user.uid;
  } //END
//=====================================

}
