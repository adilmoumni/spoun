import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';

import '../models/banners.dart';
import 'CircularLoadingWidget.dart';

class BannerChildWidget extends StatefulWidget {
  final Data banner;
  PageBar pageBar;

  BannerChildWidget(this.banner, {Key key, this.pageBar}) : super(key: key);

  @override
  _BannerChildWidgetState createState() => _BannerChildWidgetState();
}

class _BannerChildWidgetState extends State<BannerChildWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
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
      child: GestureDetector(
        onTap: () {
//          Navigator.of(context).pushNamed('/RestaurantPage',
//              arguments: widget.banner.restaurantId);
          widget.pageBar.showRestaurant(widget.banner.restaurantId);
        },
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.banner.imageUrl,
              placeholder: (context, url) => CircularLoadingWidget(height: 50),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            )),
      ),
    );
  }
}
