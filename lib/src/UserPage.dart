import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hi_world/src/GPS.dart';
import 'package:hi_world/src/Widget/Tabs.dart';
// ignore: camel_case_types
class UserPage extends StatefulWidget {
  //UserPage({Key key}) : super(key: key);
  @override
  UserPage_State createState() => UserPage_State();
}

class UserPage_State extends State<UserPage> {
  int selectedIndex = 0;
  Widget _myMap = GPS_tracker();
  Widget _myProfile = MyProfile();
  Widget _myOtherUsers = OtherUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 30,
        title: Text("GPS TRACKER"),
      ),
      body:  this.getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation_outlined),
            title: Text("Map"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text("Other Users"),
          )
        ],
        onTap: (int index) {
          this.onTapHandler(index);
        },
      ),
    );
  }

  Widget getBody( )  {
    if(this.selectedIndex == 0) {
      return this._myMap;
    } else if(this.selectedIndex == 1)
      return this._myProfile;
    else
      return this._myOtherUsers;
  }

  void onTapHandler(int index)  {
    this.setState(() {
      this.selectedIndex = index;
    });
  }
}
