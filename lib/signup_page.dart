import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup now")),
      body: mainContent(),
    );
  }

  Widget mainContent() {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return "email cannot be empty";
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: 'Your email'),
            ),
            TextFormField(
              validator: (input) {
                if (input.isEmpty) {
                  return "Please provide a password";
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: 'Your password'),
              obscureText: true,
            ),
            FlatButton(
              onPressed: signUp,
              child: Text("Sign Up", style: TextStyle(color: Colors.white)),
              color: Colors.blue,
            ),
          ],
        ));
  }

  void signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        user.sendEmailVerification();

        setDisplayName(user);

        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } catch (e) {
        print(e.message);
      }
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
  }
}
