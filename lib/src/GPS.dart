import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hi_world/src/Global.dart';

// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

final gps_key = new GlobalKey<MapState>();

class GPS_tracker extends StatefulWidget {
  @override
  MapState createState() => MapState();
}

final Set<Marker> markers = new Set<Marker>();

// ignore: non_constant_identifier_names
class MapState extends State<GPS_tracker> {
  Completer<GoogleMapController> controller1;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition = LatLng(10.7901095, 106.6553449);

  static LatLng _lastMapPosition = _initialPosition;
  /*
  _createMarkers(double lat, double long) {
    print(lat);
    print(long);
    var markerIdVal = markers.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker =
        Marker(markerId: markerId, position: LatLng(lat, long));

/*
    setState(() {
      markers.add(marker);
    });
  */
    markers.add(marker);
  }

  // */
  /*
  _createMarkers() {

  }

   */
  /// FIREBASE
  final databaseRef = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  Future add_Location(double lat, double long) async {
    while(true){
      await new Future.delayed(new Duration(seconds: 5));
      databaseRef
          .child(Credentials.name)
          .update({'Latitude': lat, 'Longitude': long});
    }

  }

  ///
  @override
  void initState() {
    super.initState();
    _getOtherUsersLocation();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      // _createMarkers(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
    print(position.latitude);
  }

  void _getOtherUsersLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    add_Location(position.latitude, position.longitude);
  }

  MapType _currentMapType = MapType.hybrid;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 5.0,
      fillColor: color,
      padding: const EdgeInsets.all(5.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Stack(children: <Widget>[
                  GoogleMap(
                    markers: markers,
                    mapType: _currentMapType,
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 14.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) {},
                    zoomGesturesEnabled: true,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    myLocationButtonEnabled: true,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 15.0, 305.0, 0.0),
                        child: Column(
                          children: <Widget>[
                            mapButton(
                                _onMapTypeButtonPressed,
                                Icon(
                                  IconData(62694,
                                      fontFamily: CupertinoIcons.iconFont,
                                      fontPackage:
                                          CupertinoIcons.iconFontPackage),
                                ),
                                Colors.lightBlueAccent),
                          ],
                        )),
                  )
                ]),
              );
            }
          }),
    );
  }
}

/// NOT THE GPS
class OtherUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double long = 0, lat = 0;

    final databaseRef = FirebaseDatabase.instance.reference();
    DatabaseReference _userRef, _userRefLat, _userRefLong;
    _userRef =
        databaseRef.reference().child(Credentials.name).child('Other Users');

    String UserName;

    var markerIdVal;
    String mar;
    MarkerId markerId;
    Marker marker;

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
                          onTap: () async => {
                            _userRefLat = databaseRef
                                .reference()
                                .child(snapshot.value['Name'])
                                .child('Latitude'),
                            _userRefLong = databaseRef
                                .reference()
                                .child(snapshot.value['Name'])
                                .child('Longitude'),
                            _userRefLat.once().then((DataSnapshot snapshot) {
                              lat = snapshot.value;
                            }),
                            _userRefLong.once().then((DataSnapshot snapshot) {
                              long = snapshot.value;
                            }),
                            await Future.delayed(
                                const Duration(seconds: 2), () {}),
                            print(lat),
                            print(long),

                              markerIdVal = markers.length + 1,
                              mar = markerIdVal.toString(),
                              markerId = MarkerId(mar),
                              marker = Marker(
                                  markerId: markerId,
                                  position: LatLng(lat, long)),
                              markers.add(marker),

                            print(markers.length),
                          },
                        );
                      }))
            ],
          ),
        ))
      ],
    )));
  }
}
