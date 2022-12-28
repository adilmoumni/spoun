import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/diningArea_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PreferredMealsWidget.dart';
import '../elements/RestaurantWidget.dart';
import '../helpers/cuisines_filters_listener.dart';
import '../models/DiningRestaurantResponse.dart';
import '../models/Meals.dart';
import '../models/filters_list_response.dart';
import '../repository/dining_area_repository.dart';
import 'filters.dart';

class DiningAreaWidget extends StatefulWidget {
  final String diningAreaId;
  PageBar pageBar;
  List<Data> allRestaurantsList;

  DiningAreaWidget(this.diningAreaId, {Key key, this.pageBar})
      : super(key: key);

  @override
  _DiningAreaWidgetState createState() => _DiningAreaWidgetState();
}

class _DiningAreaWidgetState extends StateMVC<DiningAreaWidget>
    implements CuisinesFiltersListener {
  List<Meal> preferredMealsList;
  DiningAreaController _con;
  List<Cuisine> cuisines;
  List<Data> allRestaurantsList;
  List<Data> filteredRestaurantsList = new List<Data>();
  bool isSearchBarOpen = false;
  TextEditingController searchBarController = new TextEditingController();
  int cartCount;
  int notificationsCount;

  _DiningAreaWidgetState() : super(DiningAreaController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

    /// register
    FBroadcast.instance().register(Constants.cartCount, (value, callback) {
      /// get data
      cartCount = value;
      setState(() {});
    });

    /// register
    FBroadcast.instance().register(Constants.unreadNotificationsCount,
            (value, callback) {
          /// get data
          notificationsCount = value;
          setState(() {});
        });
    CommonMethods.getCartCount();
    CommonMethods.getNotifications();
    getRestaurants();
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
            key: _con.scaffoldKey,
            appBar: AppBar(
              elevation: 0,
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
                                .pushReplacementNamed('/Pages', arguments: 0);
                          },
                          child: Padding(
                              padding:
                              const EdgeInsets.only(right: 8, left: 5),
                              child:   Icon(Platform.isAndroid
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FiltersWidget(
                                  cuisinesFiltersListener: this,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5, left: 0),
                            child: IconButton(
                                icon: Image.asset("assets/img/filters.png"),
                                color: null),
                          ),
                        ),
                      ),
                      isSearchBarOpen ?  Expanded(
                          child: Padding(padding:
                          const EdgeInsets.only(right: 10, left: 0),
                            child: TextField(
                              controller: searchBarController,
                              style: TextStyle(color: Colors.black26),
                              decoration: new InputDecoration(
                                  hintText: 'Search Restaurant',
                                  hintStyle:
                                  TextStyle(color: Colors.black26),
                                  border: InputBorder.none),
                              onChanged: onSearchTextChanged,
                            ),
                          )) :
                      Padding(padding: EdgeInsets.only(right: 0,left: 00,top: 0),
                        child: allRestaurantsList == null
                            ? CircularLoadingWidget(height: 10,)
                            : allRestaurantsList.first.diningName == null
                            ? Text ("Dining Area", style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey
                        ),)
                            : Text( allRestaurantsList.first.diningName,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey
                          ),
                        ),
                      ),
                      Expanded(
                        child: isSearchBarOpen
                            ? Padding(
                            padding:
                            const EdgeInsets.only(right: 0, left: 0),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(right: 0, left: 0),
                              // child: TextField(
                              //   controller: searchBarController,
                              //   style: TextStyle(color: Colors.black26),
                              //   decoration: new InputDecoration(
                              //       hintText: 'Search Restaurant',
                              //       hintStyle:
                              //           TextStyle(color: Colors.black26),
                              //       border: InputBorder.none),
                              //   onChanged: onSearchTextChanged,
                              // ),
                            ))
                            : Padding(
                            padding: EdgeInsets.only(
                                right: 0, left: TextSize.LEFT_TITLE_PADDING),
                            child: InkWell(
                              onTap: () {
                                isSearchBarOpen = true;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 0, left: 0),
                                child: Icon(Icons.search,
                                    color: Colors.black26),
                              ),
                            )),
                      ),
                      isSearchBarOpen
                          ? IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          isSearchBarOpen = false;
                          searchBarController.clear();
                          onSearchTextChanged('');
                        },
                      )
                          : Text(''),
                      Padding(
                        padding: const EdgeInsets.only(right: 0, left: 0),
                        child: InkWell(
                          onTap: () {
                            widget.pageBar.notifications('notifications');
                          },
                          child: Padding(
                              padding:
                              const EdgeInsets.only(right: 12, left: 0),
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
                                    color: Colors.deepPurpleAccent,
                                    size: 28),
                              )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 12, right: 12, bottom: 12),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  PreferredMealsWidget(
                    S.of(context).preferredMeals,
                    Constants.PREFERRED_MEALS_TYPE_DINING_AREA,
                    widget.diningAreaId,
                    null,
                    pageBar: widget.pageBar,
                  ),
                  Column(children: [
                    ListTile(
                      dense: true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: TextSize.TEXT3),
                      title: Text(
                        S.of(context).restaurants,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat-Regular',
                          fontSize: TextSize.TEXT3,
                        ),
                      ),
                    ),
                    getRestaurantsWidget()
                  ])
                ],
              ),
            )));
  }

  onSearchTextChanged(String text) async {
    filteredRestaurantsList.clear();
    if (text.isEmpty) {
      filteredRestaurantsList.addAll(allRestaurantsList);
      setState(() {});
      return;
    }

    allRestaurantsList.forEach((restaurant) {
      if (restaurant.title.toLowerCase().contains(text.toLowerCase())) {
        filteredRestaurantsList.add(restaurant);
      }
    });
    setState(() {});
  }

  void getRestaurants() async {
    getRestaurantsInDiningArea(widget.diningAreaId, cuisines).then((value) {
      allRestaurantsList = null;
      filteredRestaurantsList.clear();
      if (value.response.data != null && value.response.data.isNotEmpty) {
        allRestaurantsList = value.response.data;
        filteredRestaurantsList.addAll(value.response.data);
      }
      setState(() {});
    });
  }

  Widget getRestaurantsWidget() {
    if (filteredRestaurantsList == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (filteredRestaurantsList == null || filteredRestaurantsList.isEmpty)
      return Container(
        child: Text("No Restaurants"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );

    return Container(
        margin: EdgeInsets.only(
            left: TextSize.TEXT,
            right: TextSize.TEXT,
            top: TextSize.TEXT,
            bottom: TextSize.TEXT),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: filteredRestaurantsList.length,
          itemBuilder: (context, index) {
            return RestaurantWidget(
              filteredRestaurantsList[index],
              pageBar: widget.pageBar,
            );
          },
        ));
  }

  @override
  onCuisinesSelected(List<Cuisine> cuisines) {
    this.cuisines = cuisines;
    allRestaurantsList = null;
    setState(() {});
    getRestaurants();
  }
}

