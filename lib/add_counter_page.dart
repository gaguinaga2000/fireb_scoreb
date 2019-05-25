import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './login_page.dart';
import 'all_counters_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './counter_page.dart';
import './profile_page.dart';
import './reset_pass_page.dart';

class AddCounterPage extends StatefulWidget {
  final String title;
  final VoidCallback onSignedOut;

  final FirebaseUser user;

  AddCounterPage({Key key, this.title, this.user, this.onSignedOut})
      : super(key: key);

  @override
  _AddCounterPageState createState() => _AddCounterPageState();
}

class _AddCounterPageState extends State<AddCounterPage> {
  var counterNameController = TextEditingController();
  String _counterName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0), child: mainContent(_counterName)),
    );
  }

  Widget mainContent(String _counterName) {
    return Column(children: <Widget>[
      newCounter(),
      saveButton(),
      Text("You entered: $_counterName"),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AllCountersPage(name: _counterName, user: widget.user)));
        },
        child: Text("all counters"),
      ),
      FlatButton(
        color: Colors.grey,
        textColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                      user: widget.user, onSignedOut: widget.onSignedOut)));
        },
        child: Text("Update Profile"),
      ),
      logOutBtn(),
      resetBtn(),
    ]);
  }

  Widget newCounter() {
    return Column(
      children: <Widget>[
        Container(
          child: TextField(
            keyboardType: TextInputType.text,
            controller: counterNameController,
            onChanged: (String name) {
              setState(() {
                _counterName = name;
              });
            },
            decoration: InputDecoration(
              hintText: "Enter counter name",
              hintStyle: TextStyle(fontSize: 20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget saveButton() {
    return FlatButton(
      color: Colors.blue,
      textColor: Colors.white,
      onPressed: () {
        createData();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CounterPage(name: _counterName, user: widget.user)));
      },
      child: Text("SAVE"),
    );
  }

//Createds and stores counter info in Firebase
  void createData() async {
    DocumentReference docReference = Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .collection("counters")
        .document(_counterName);

    Map<String, dynamic> newCounter = {
      "count": 0,
      "name": _counterName,
      "created_on": DateTime.now().toUtc().millisecondsSinceEpoch,
    };

    await docReference.setData(newCounter);
  } //ENd createDate function
  //======================================

//Reset Button
  Widget resetBtn() {
    return FlatButton(
        color: Colors.blue,
        child: Text("RESET"),
        onPressed: () {
          invokeResetPage();
        });
  }
//=================================

void invokeResetPage(){

 Navigator.push(
       context,
           MaterialPageRoute(builder: (context) => ResetPage(user: widget.user)));  
 
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
    } catch (e) {
      print(e);
    }
  } //END signout function
//====================================

  Future<void> sendPasswordResetEmail(String email) async {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

//Firebase signout
  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  } //END
//===============================================

//---------------------------------------------------
}
