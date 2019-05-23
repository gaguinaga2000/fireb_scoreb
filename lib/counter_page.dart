import 'package:fireb_scoreb/all_counters_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './add_counter_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import './main.dart';

class CounterPage extends StatefulWidget {
  final String name;
  final FirebaseUser user;
  CounterPage({Key key, this.name, this.user}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter;

  Widget returnCount() {
    DocumentReference documentReference =
        Firestore.instance.collection(widget.user.uid).document(widget.name);
    documentReference.get().then((datasnapshot) {
      _counter = datasnapshot.data["count"];
    });

    return Text(_counter.toString());
  }

  void updateCount() {
    final DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(widget.user.uid)
        .collection("counters")
        .document(widget.name);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot docSnapshot = await tx.get(docRef);
      if (docSnapshot.exists) {
        await tx.update(
            docRef, <String, dynamic>{'count': docSnapshot.data['count'] + 1});
      }
    });

    print(widget.name);
  }

  void _incrementCounter() {
    setState(() {
      updateCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: displayResults(),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

//Firestore.instance.collection('users').document(widget.user.uid).collection("counters").document(widget.name);
  Widget displayResults() {
    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .document(widget.user.uid)
              .collection("counters")
              .document(widget.name)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            var magicDoc = snapshot.data;
            return Center(
              child: Container(
                  child: Text(magicDoc["count"].toString(),
                      style: TextStyle(fontSize: 55.0))),
            );
          },
        ),
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AllCountersPage(name: widget.name, user: widget.user)));
          },
          child: Text("all counters"),
        ),
        newCounterBtn(context, widget.user),
      ],
    );
  }
}

//==========================================
Widget newCounterBtn(context, user) {
  return FlatButton(
    color: Colors.blue,
    textColor: Colors.white,
    onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyApp()));
    },
    child: Text("New Counter"),
  );
}
