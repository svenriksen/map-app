import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_world/src/Global.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white30,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              "https://img.favpng.com/25/13/19/samsung-galaxy-a8-a8-user-login-telephone-avatar-png-favpng-dqKEPfX7hPbc6SMVUCteANKwj.jpg"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    //Credentials.name,
                    'YOUR NAME',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      Credentials.email,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OtherUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final databaseRef = FirebaseDatabase.instance.reference();
    DatabaseReference _userRef =
        databaseRef.reference().child(Credentials.name).child('Other Users');
    String UserName;
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Center(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text(
                "Other users",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: InputDecoration(hintText: "Username"),
                onChanged: (value) {
                  UserName = value;
                },
                textAlign: TextAlign.center,
              ),
              FlatButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    databaseRef
                        .child(Credentials.name)
                        .child('Other Users')
                        .push()
                        .set({
                      'Name': UserName,
                    });
                  },
                  child: Text('ADD')),
              Flexible(
                  child: new FirebaseAnimatedList(
                      shrinkWrap: true,
                      query: _userRef,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return new ListTile(
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                _userRef.child(snapshot.key).remove(),
                          ),
                          title: new Text(snapshot.value['Name']),
                        );
                      }))
            ],
          ),
        ))
      ],
    )));
  }
}
