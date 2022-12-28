import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';
import 'package:geolocator/geolocator.dart';

import '../models/DiningArea.dart';
import '../repository/dining_area_repository.dart';
import 'CircularLoadingWidget.dart';
import 'DiningAreaNearbyChildWidget.dart';

class DiningAreasNearbyWidget extends StatefulWidget {
  Position position;
  PageBar pageBar;

  DiningAreasNearbyWidget(currentLocation, {Key key, this.pageBar}) : super(key: key) {
    this.position = currentLocation;
  }



  @override
  _DiningAreasNearbyWidgetState createState() =>
      _DiningAreasNearbyWidgetState(position);
}

class _DiningAreasNearbyWidgetState extends State<DiningAreasNearbyWidget> {
  List<Data> diningAreas;
  Position position;

  _DiningAreasNearbyWidgetState(Position position) {
    this.position = position;
  }

  Future<String> getData() async {
    String latitude, longitude;
    if (position != null) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    }
    diningArea(latitude, longitude).then((value) {
      diningAreas = value.response.data;
      setState(() {});
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            title: Text(
              S.of(context).dining_areas_near_you,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Regular',
                fontSize: 19,
              ),
            ),
          ),
        ),
        getAreas()
      ],
    );
  }

  Widget getAreas() {
    if (diningAreas == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (diningAreas.isEmpty) {
      return Container(
        child: Text("No Data"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );
    }
    return Container(
      height: 240,
      // color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: diningAreas.length,
        itemBuilder: (context, index) {
          return DiningAreaNearbyChildWidget(diningAreas[index], pageBar : widget.pageBar);
        },
      ),
    );
  }
}
