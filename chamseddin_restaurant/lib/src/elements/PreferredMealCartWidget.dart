import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/item_details.dart';
import 'package:food_delivery_app/src/models/meal_details.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/restaurant_controller.dart';
import '../helpers/refresh_cart_listener.dart';
import '../models/Meals.dart';
import '../models/meal_customisation_arguments.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';

class PreferredMealCartWidget extends StatefulWidget {
  final Meal meal;
  final int restaurantId;
  final RefreshCartListener refreshCartListener;
  PageBar pageBar;

  PreferredMealCartWidget(
      this.meal, this.restaurantId, this.refreshCartListener,
      {Key key, this.pageBar})
      : super(key: key);

  @override
  _PreferredMealCartWidgetState createState() =>
      _PreferredMealCartWidgetState();
}

class _PreferredMealCartWidgetState extends StateMVC<PreferredMealCartWidget> {
  RestaurantController _con;

  _PreferredMealCartWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width / 3,
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
      child: Container(
        child: GestureDetector(
          onTap: () {
            openMealCustomisationPage();
          },
          child: Container(
              child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  height: 180,
                  width: MediaQuery.of(context).size.width - 140.0,
                  fit: BoxFit.cover,
                  imageUrl: widget.meal.imageName,
                  placeholder: (context, url) =>
                      CircularLoadingWidget(height: 50),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Container(
                  color: Colors.black45,
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 0,
                  child: Column(
                    children: [
                      Text(
                        widget.meal.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.meal.price.toString() +
                            widget.meal.currencySymbol,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ))
            ],
          )),
        ),
      ),
    );
  }

  openMealCustomisationPage() {
    MealCustomizationArguments mealCustomizationArguments =
        new MealCustomizationArguments(null, widget.meal);
    if (widget.meal.type == 'meal') {
      getMealDetails(widget.meal.id.toString()).then((response) {
        if (response.statusCode == 200) {
          var mealDetails = MealDetails.fromJson(json.decode(response.body));
          if (!CommonMethods.isMealEmpty(mealDetails)) {
//            Navigator.of(context).pushNamed('/MealCustomisationPage',
//                arguments: mealCustomizationArguments);
            widget.pageBar.mealCustomization(mealCustomizationArguments);
          } else {
            _con
                .addMealToCart(
                    context,
                    _con.scaffoldKey,
                    0,
                    widget.meal.id,
                    widget.meal.price,
                    null,
                    null,
                    widget.meal.restaurantId,
                    1,
                    false)
                .then((value) {
              if (value != null) {
                if (value.response.code == 200) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(value.response.message)));
                } else if (value.response.code == 202) {
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(context);
                      _con
                          .addMealToCart(
                              context,
                              _con.scaffoldKey,
                              0,
                              widget.meal.id,
                              widget.meal.price,
                              null,
                              null,
                              widget.meal.restaurantId,
                              1,
                              true)
                          .then((value) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(value.response.message)));
                      });
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text('Reset Cart'),
                    content: Text(value.response.message),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              }
            });
          }
        } else if (response.statusCode == 202) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        } else {
          print(CustomTrace(StackTrace.current, message: response.body)
              .toString());
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        }
      });
    } else {
      getItemDetails(widget.meal.id.toString()).then((response) {
        if (response.statusCode == 200) {
          var itemDetails = ItemDetails.fromJson(json.decode(response.body));
          if (!CommonMethods.isItemEmpty(itemDetails)) {
//            Navigator.of(context).pushNamed('/ItemCustomisationPage',
//                arguments: mealCustomizationArguments);
            widget.pageBar.itemCustomization(mealCustomizationArguments);
          } else {
            _con
                .addItemToCart(
                    context,
                    _con.scaffoldKey,
                    0,
                    widget.meal.id,
                    widget.meal.price,
                    null,
                    null,
                    widget.meal.restaurantId,
                    1,
                    false)
                .then((value) {
              if (value != null) {
                if (value.response.code == 200) {
                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(value.response.message)));
                } else if (value.response.code == 202) {
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(context);
                      _con
                          .addItemToCart(
                              context,
                              _con.scaffoldKey,
                              0,
                              widget.meal.id,
                              widget.meal.price,
                              null,
                              null,
                              widget.meal.restaurantId,
                              1,
                              true)
                          .then((value) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(value.response.message)));
                      });
                    },
                  );

                  // set up the AlertDialog
                  AlertDialog alert = AlertDialog(
                    title: Text('Reset Cart'),
                    content: Text(value.response.message),
                    actions: [
                      cancelButton,
                      continueButton,
                    ],
                  );

                  // show the dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    },
                  );
                }
              }
            });
          }
        } else if (response.statusCode == 202) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        } else {
          print(CustomTrace(StackTrace.current, message: response.body)
              .toString());
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        }
      });
    }
  }
}
