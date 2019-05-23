import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:timeago/timeago.dart';
import 'package:intl/intl.dart';
import './counter_page.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class AllCountersPage extends StatefulWidget {
  AllCountersPage({Key key, this.name, this.user}) : super(key: key);

  final String name;

  final FirebaseUser user;

  @override
  _AllCountersPageState createState() => _AllCountersPageState();
}

class _AllCountersPageState extends State<AllCountersPage> {
  //returns a counter Block
  Widget displayCounter(String name, int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    String formattedDate = DateFormat("M-dd-yyyy").format(date);
    //  print(DateFormat("M-dd-yyyy").format(date));
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Colors.grey[700]),
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(fontSize: 21.0)),
        subtitle: Text(formattedDate, style: TextStyle(fontSize: 18.0)),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CounterPage(name: name, user: widget.user)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("All Counters")),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(widget.user.uid)
              .collection("counters")
              .orderBy('created_on', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } //fixes returning null error
            return Container(
              alignment: Alignment.topCenter,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: displayCounter(ds['name'], ds['created_on']),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }


}
