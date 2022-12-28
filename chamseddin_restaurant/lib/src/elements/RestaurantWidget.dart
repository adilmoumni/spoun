import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';

import '../models/DiningRestaurantResponse.dart';
import 'CircularLoadingWidget.dart';

class RestaurantWidget extends StatefulWidget {
  final Data restaurant;
  PageBar pageBar;

  RestaurantWidget(this.restaurant, {Key key, this.pageBar}) : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends State<RestaurantWidget> {
  DiningRestaurantResponse diningRestaurantResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.pageBar.showRestaurant(widget.restaurant.restaurantId);
//        Navigator.of(context).pushNamed('/RestaurantPage',
//            arguments: widget.restaurant.restaurantId);
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(

            width: TextSize.POST_CAROUSEL_WIDTH,
            height: TextSize.CIRCLE_BORDER,
            // margin: EdgeInsets.only(left: TextSize.TEXT, right: TextSize.TEXT, top: TextSize.TEXT, bottom: TextSize.TEXT),
            decoration: BoxDecoration(
               color: Theme.of(context).primaryColor,
              // color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: Offset(0, 5)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 2,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        child: CachedNetworkImage(
                          width: TextSize.REVENUE_BUTTON_WIDTH,
                          height: TextSize.SHORT_DROPDOWN_WIDTH,
                          fit: BoxFit.cover,
                          imageUrl: widget.restaurant.imageUrl == null ? 'http://chamseddinprod.n1.iworklab.com/images/restaurant_image/rest1.jpeg'
                              :widget.restaurant.imageUrl,
                          placeholder: (context, url) => CircularLoadingWidget(height: 50),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        )
                    )
                ),
                Padding(
                  padding: EdgeInsets.all(TextSize.TEXT),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: TextSize.POPUP_BUTTON_WIDTH,
                        child: Text(
                          widget.restaurant.title,
                          style: TextStyle(
                              fontSize: TextSize.CVV_PADDING_SIZE,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6244E8),
                              fontFamily: 'Montserrat-Bold'),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                      Container(
                          width: TextSize.BUTTON_WIDTH2,
                          child: widget.restaurant.location == null
                              ? Text("No Location")
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.location_on, size: 10,),
                              Expanded(
                                child : Text(
                                " " + widget.restaurant.location,
                                style: TextStyle(fontSize: TextSize.BUTTON),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),)
                            ],
                          )

                      ),
                      Container(
                        width: TextSize.POPUP_BUTTON_WIDTH,
                        child: widget.restaurant.rating == null
                            ? Text("N/A")
                            : Row(
                          children: [
                            Icon(Icons.star,size: 10,),
                            Text(
                              " " + widget.restaurant.rating + " (" + widget.restaurant.ratingCount.toString() +")",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: const Color(0xFF6244E8))),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/RestaurantMap',
                              arguments: widget.restaurant);
                        },
                        color: const Color(0xFF6244E8),
                        textColor: Colors.white,
                        child: Text("View map", style: TextStyle(fontSize: 8)),
                      )
                    ],
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
