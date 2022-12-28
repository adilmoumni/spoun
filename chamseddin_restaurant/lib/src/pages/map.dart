import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/DiningRestaurantResponse.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/map_controller.dart';
import '../elements/CircularLoadingWidget.dart';

class MapWidget extends StatefulWidget {
  String restaurantAddress;
  DiningRestaurantResponse diningRestaurantResponse;
  Data restaurant;

  MapWidget(this.restaurant);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends StateMVC<MapWidget> {
  MapController _con;
  String restaurantAddress;
  Coordinates restaurantCoordinates;
  CameraPosition cameraPosition;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon:   Icon(Platform.isAndroid
              ? Icons.arrow_back
              : Icons.arrow_back_ios_sharp),
         color: Theme.of(context).hintColor,
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
              _getUserLocation();
            },
          ),
        ],
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
                   GoogleMap(
                          mapToolbarEnabled: true,
                          mapType: MapType.normal,
                          initialCameraPosition:
                          CameraPosition(
                     target: widget.restaurant.lat== null && widget.restaurant.lng == null
                            ? LatLng(double.parse(widget.restaurant.lat),
                         double.parse(widget.restaurant.lng))
                     : LatLng(double.parse(widget.restaurant.lat),
                         double.parse(widget.restaurant.lng)),
                     zoom: 8.4746,
                   ),
                          markers: myMarkers(),
                          onMapCreated: _onMapCreated,
                          onCameraMove: _onCameraMove,
//                          onCameraIdle: () {
//                            _con.getRestaurantsOfArea();
//                          },
//                          polylines: _con.polylines,
                        ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(
                  children: <Widget>[
                    mapButton(_onAddMarkerButtonPressed,
                        Icon(
                            Icons.add_location
                        ), Colors.blue),
//                    mapButton(
//                        _onMapTypeButtonPressed,
//                        Icon(
//                          IconData(0xf473,
//                              fontFamily: CupertinoIcons.iconFont,
//                              fontPackage: CupertinoIcons.iconFontPackage),
//                        ),
//                        Colors.green),
                  ],
                )),
          )
        ],
      ),
    );
  }

  LatLng currentPostion;
  static LatLng _initialPosition;
  final Set<Marker> _markers = Set();
  static  LatLng _lastMapPosition = _initialPosition;

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        print('placemarker ::: ${placemark[0].name}');
      });
  }


  myMarkers() {
    List<Marker> mMarkers = [];
    mMarkers.add(
      Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(double.parse(widget.restaurant.lat),
            double.parse(widget.restaurant.lng)),
        infoWindow: InfoWindow(
            title: widget.restaurant.title,
            snippet: widget.restaurant.location,
            onTap: (){
            }
        ),
      ),
    );
    mMarkers.add(
      Marker(
        markerId: MarkerId('marker1'),
        position: LatLng(double.parse(widget.restaurant.lat),
            double.parse(widget.restaurant.lng)),
        infoWindow: InfoWindow(
            title: widget.restaurant.title,
            snippet: widget.restaurant.location,
            onTap: (){
            }
        ),
      ),
    );
    return mMarkers.toSet();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(
          Marker(
              markerId: MarkerId(_lastMapPosition.toString()),
              position: LatLng(double.parse(widget.restaurant.lat),
                  double.parse(widget.restaurant.lng)),
              infoWindow: InfoWindow(
                  title: widget.restaurant.title,
                  snippet: widget.restaurant.location,
                  onTap: (){
                  }
              ),
              onTap: (){
              },

              icon: BitmapDescriptor.defaultMarker));
    });
  }
  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }
}
