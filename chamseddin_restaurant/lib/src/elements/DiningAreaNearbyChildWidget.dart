import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';

import '../models/DiningArea.dart';
import 'CircularLoadingWidget.dart';

class DiningAreaNearbyChildWidget extends StatefulWidget {
  Data diningArea;
  PageBar pageBar;

  DiningAreaNearbyChildWidget(Data restaurantsList, {Key key, this.pageBar}) : super(key: key) {
    diningArea = restaurantsList;
  }

  @override
  _DiningAreaNearbyChildWidgetState createState() =>
      _DiningAreaNearbyChildWidgetState(diningArea);
}

class _DiningAreaNearbyChildWidgetState extends State<DiningAreaNearbyChildWidget> {
  Data diningArea;

  _DiningAreaNearbyChildWidgetState(diningArea) {
    this.diningArea = diningArea;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.pageBar.showDiningArea(diningArea.dinningId.toString(),);
//        Navigator.of(context).pushNamed('/DiningArea',
//            arguments: diningArea.dinningId.toString());
      },
      child: Container(
        width: TextSize.PRODUCT_IMAGE_WIDTH,
        margin: EdgeInsets.only(left: TextSize.TEXT_PADDING, right: 5, top: 15, bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image of the card
            Hero(
              tag: diningArea.dinningId,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 150,
                    fit: BoxFit.cover,
                    imageUrl: diningArea.imageName,
                    placeholder: (context, url) =>
                        CircularLoadingWidget(height: 50),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          diningArea.dinningName,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6244E8),
                              fontFamily: 'Montserrat-Bold'),
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ],
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
