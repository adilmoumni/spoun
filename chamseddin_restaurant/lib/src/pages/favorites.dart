import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/controllers/restaurant_controller.dart';
import 'package:food_delivery_app/src/elements/EmptyFavouriteWidget.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../constants.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/FavoriteGridItemWidget.dart';
import '../elements/FavoriteListItemWidget.dart';
import '../models/get_favorites_response.dart';

class FavoritesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  PageBar pageBar;

  FavoritesWidget({Key key, this.parentScaffoldKey, this.pageBar})
      : super(key: key);

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends StateMVC<FavoritesWidget>
    implements FavoritesClickListener {
  String layout = 'grid';

  RestaurantController _con;
  GetFavoritesResponse getFavoritesResponse;
  int notificationsCount;

  _FavoritesWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

    FBroadcast.instance().register(Constants.unreadNotificationsCount,
        (value, callback) {
      notificationsCount = value;
      setState(() {});
    });
    getAllFavorites();
    CommonMethods.getNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  Future<bool> _onWillPop() async {
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PagesWidget(
            currentTab: 0,
          );
        },
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/Pages', arguments: 0);
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 8, left: 10),
                            child: Icon(
                              Platform.isAndroid
                                  ? Icons.arrow_back
                                  : Icons.arrow_back_ios_sharp,
                              color: Colors.black26,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0, left: 0),
                      child: InkWell(
                        onTap: () {
                          widget.pageBar.notifications('notifications');
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 0),
                            child: IconButton(
                              icon: notificationsCount != null &&
                                      notificationsCount > 0
                                  ? Badge(
                                      badgeContent: Text(
                                        notificationsCount.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      child: Icon(Icons.notifications,
                                          color: Colors.deepPurpleAccent,
                                          size: 28),
                                      badgeColor: Colors.deepPurpleAccent,
                                    )
                                  : Icon(Icons.notifications,
                                      color: Colors.deepPurpleAccent, size: 28),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          key: _con.scaffoldKey,
          body: getFavoritesResponse == null
              ? CircularLoadingWidget(
                  height: 50,
                )
              : getFavoritesResponse.response.data == null
                  ? EmptyFavouriteWidget()
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[],
                              ),
                            ),
                          ),
                          getFavoritesResponse == null
                              ? CircularLoadingWidget(height: 500)
                              : Offstage(
                                  offstage: this.layout != 'list',
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: getFavoritesResponse
                                        .response.data.length,
                                    separatorBuilder: (context, index) {
                                      return SizedBox(height: 10);
                                    },
                                    itemBuilder: (context, index) {
                                      return FavoriteListItemWidget(
                                        heroTag: 'favorites_list',
                                        favorite: getFavoritesResponse
                                            .response.data
                                            .elementAt(index),
                                      );
                                    },
                                  ),
                                ),
                          getFavoritesResponse == null
                              ? CircularLoadingWidget(height: 500)
                              : Offstage(
                                  offstage: this.layout != 'grid',
                                  child: GridView.count(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this produces 2 rows.
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? 2
                                            : 4,
                                    // Generate 100 widgets that display their index in the List.
                                    children: List.generate(
                                        getFavoritesResponse
                                            .response.data.length, (index) {
                                      return FavoriteGridItemWidget(
                                        heroTag: 'favorites_grid',
                                        meal_id: getFavoritesResponse
                                            .response.data[index].id
                                            .toString(),
                                        favorite: getFavoritesResponse
                                            .response.data
                                            .elementAt(index),
                                        favoritesClickListener: this,
                                      );
                                    }),
                                  ),
                                )
                        ],
                      ),
                    ),
        ));
  }

  @override
  onFavoritesBtnClicked(String meal_id) {
    _con.removeMealFromFavourite(meal_id).then((value) {
      getAllFavorites();
    });
  }

  void getAllFavorites() {
    _con.getAllFavouriteMeals().then((value) {
      this.getFavoritesResponse = value;
      setState(() {});
    });
  }

  Future<T> pushPage<T>(BuildContext context, Widget page) {
    return Navigator.of(context)
        .push<T>(MaterialPageRoute(builder: (context) => page));
  }
}
