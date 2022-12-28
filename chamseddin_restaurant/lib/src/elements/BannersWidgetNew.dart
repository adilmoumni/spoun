import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:geolocator/geolocator.dart';

import '../elements/BannerChildWidget.dart';
import '../models/banners.dart';
import '../repository/restaurant_repository.dart';
import 'CircularLoadingWidget.dart';

class BannersWidgetNew extends StatefulWidget {
//  dynamic banners;
  Position position;
  List<Data> banners;
  PageBar pageBar;

//  BannersWidgetNew(currentLocation,  {
//    Key key,
//    this.banners,
//  }) : super(key: key);

  BannersWidgetNew(currentLocation, {Key key, this.pageBar}) : super(key: key) {
    this.position = currentLocation;
  }

  @override
  _BannersWidgetNewState createState() => _BannersWidgetNewState(position);
}

class _BannersWidgetNewState extends State<BannersWidgetNew> {
  String heroTag;
//  Banners banners;
  List<Data> banners;
  Position position;

  _BannersWidgetNewState(Position position) {
    this.position = position;
  }

  Future<String> getData() async {
    String latitude, longitude;
    if (position != null) {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    }
    getBanner(latitude, longitude).then((value) {
      banners = value.response.data;
      // setState(() {});
      if (mounted) {
        setState(() => 'No Data');
      }
    });
    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    if (banners == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (banners.isEmpty == null) {
      return Container(
        child: Text("No Data"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );
    }

    final children = <Widget>[];
    for (var i = 0; i < banners.length; i++) {
      children.add(BannerChildWidget(
        banners[i],
        pageBar: widget.pageBar,
      ));
    }
    CarouselController buttonCarouselController = CarouselController();
    return Column(
      children: [
        CarouselSlider(
            items: children,
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: 200,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            )),
      ],
    );
  }
}
