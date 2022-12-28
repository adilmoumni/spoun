import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/PreferredMealsWidget.dart';
import '../elements/RestaurantMealsListWidget.dart';
import '../elements/SearchChildWidget.dart';
import '../helpers/common_methods.dart';
import '../models/Meals.dart';
import '../models/restaurant_details.dart';
import '../repository/restaurant_repository.dart';
import '../models/DiningArea.dart' as Data;
import 'filters.dart';

class RestaurantWidget extends StatefulWidget {
  final int restaurantId;
  PageBar pageBar;
  String diningId;

  RestaurantWidget(this.restaurantId, {Key key, this.pageBar, this.diningId})
      : super(key: key);

  @override
  _RestaurantWidgetState createState() => _RestaurantWidgetState();
}

class _RestaurantWidgetState extends StateMVC<RestaurantWidget> {
  List<Meal> preferredMealsList;
  RestaurantController _con;
  RestaurantDetails restaurantDetails;
  Category selectedCategory;
  int cartCount;
  int notificationsCount;
  bool isSearchBarOpen = false;
  TextEditingController searchBarController = new TextEditingController();

  _RestaurantWidgetState() : super(RestaurantController()) {
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
    getResDetails();
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  void getResDetails() async {
    getRestaurantDetails(widget.restaurantId).then((restaurantDetails) {
      this.restaurantDetails = restaurantDetails;
      selectedCategory = restaurantDetails.response.data.category[0];
      setState(() {});
    });
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
        onWillPop: () {
          widget.pageBar.showDiningArea(
              restaurantDetails.response.data.detail.diningId.toString());
        },
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
//                        Navigator.of(context).pushNamed('/Pages', arguments: 0);
                            widget.pageBar.showDiningArea(restaurantDetails
                                .response.data.detail.diningId
                                .toString());
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 8, left: 10),
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
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      NotificationListingWidget()),
//                            );
                            widget.pageBar.notifications('notifications');
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 0),
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
            body: Builder(
              builder: (context) {
                return getDataWidget(context);
              },
            )));
  }

  Widget getDataWidget(BuildContext context) {
    if (restaurantDetails == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        // child: Text("Loading restaurant information"),
        child: CircularLoadingWidget(height: 50),
      );
    }
    if (restaurantDetails.response == null ||
        restaurantDetails.response.data == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Restaurant information not available'),
      );
    }
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            (restaurantDetails.response.data.detail == null ||
                    restaurantDetails.response.data.detail.name == null)
                ? "Unnamed restaurant"
                : restaurantDetails.response.data.detail.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Montserrat-Regular',
              fontSize: 24,
            ),
          ),
        ),
        Container(
          child: PreferredMealsWidget(
            S.of(context).preferredMeals,
            Constants.PREFERRED_MEALS_TYPE_RESTAURANT,
            null,
            widget.restaurantId.toString(),
            pageBar: widget.pageBar,
          ),
        ),
        Container(
          // color:Colors.blue,

          height: 80,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: restaurantDetails.response.data.category.length,
            itemBuilder: (BuildContext context, int index) {
              Category category =
                  restaurantDetails.response.data.category[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () => selectCategory(category),
                  child: Card(
                    color: getCategoryColor(category),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Text(
                            category.name,
                            style: TextStyle(
                                color: getCategoryTextColor(category),
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
            child: Container(

                child: new RestaurantsMealsListWidget(
          context,
          selectedCategory.category,
          widget.restaurantId,
          pageBar: widget.pageBar,
        )))
      ],
    );
  }

  getCategoryColor(Category category) {
    if (selectedCategory.category == category.category) {
      return Colors.deepPurple;
    } else {
      return Colors.white;
    }
  }

  selectCategory(Category category) {
    selectedCategory = category;
    setState(() {});
  }

  getCategoryTextColor(Category category) {
    if (selectedCategory.category == category.category) {
      return Colors.white;
    } else {
      return Colors.black87;
    }
  }
}
