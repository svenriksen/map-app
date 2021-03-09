import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hi_world/src/loginPage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
// ignore: camel_case_types
class GPS_tracker extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<GPS_tracker> {
  Completer<GoogleMapController> controller1;

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition = LatLng(-15.4630239974464, 28.363397732282127);
  final Set<Marker> _markers = {};
  static  LatLng _lastMapPosition = _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }


  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
    });
  }

  MapType _currentMapType = MapType.hybrid;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.hybrid
          ? MapType.normal
          : MapType.hybrid;
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
      appBar: AppBar(
        title: Text("GPS TRACKER"),
      ),
      body: _initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            markers: _markers,

            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.4746,
            ),
            onMapCreated: _onMapCreated,
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
                              fontPackage: CupertinoIcons.iconFontPackage),
                        ),
                        Colors.lightBlueAccent),
                  ],
                )),
          )

        ]),

      ),

    );
  }
}
