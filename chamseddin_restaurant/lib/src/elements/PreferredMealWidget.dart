import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/item_details.dart';
import 'package:food_delivery_app/src/models/meal_details.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/restaurant_controller.dart';
import '../helpers/common_methods.dart';
import '../models/Meals.dart';
import '../models/meal_customisation_arguments.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';

class PreferredMealWidget extends StatefulWidget {
  final Meal meal;
  final int restaurantId;
  PageBar pageBar;

  PreferredMealWidget(this.meal, this.restaurantId, {Key key, this.pageBar}) : super(key: key);

  @override
  _PreferredMealWidgetState createState() => _PreferredMealWidgetState();
}

class _PreferredMealWidgetState extends StateMVC<PreferredMealWidget> {
  RestaurantController _con;

  _PreferredMealWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      width: TextSize.LOGO_WIDTH1,
      height: 350,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedNetworkImage(
            width: TextSize.SELLER_PIC_WIDTH,
            height: TextSize.PIC_DOUBLE_WIDTH,
            fit: BoxFit.cover,
            imageUrl: widget.meal.imageName,
            placeholder: (context, url) => CircularLoadingWidget(height: 50),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                // color: Colors.red,
                width: TextSize.PROFILE_PIC_WIDTH,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        child: Text(widget.meal.diningArea,
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6244E8),
                                fontFamily: 'Montserrat-Bold')),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(widget.meal.flag == null || widget.meal.flag == 'null'
                          ? ' '
                          : "   " + widget.meal.flag + "   ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          backgroundColor: widget.meal.flagColor == null
                              ? Colors.white
                              : hexToColor(widget.meal.flagColor),),),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(widget.meal.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6244E8),
                                fontFamily: 'Montserrat-Bold')),
                      ),
                    ),
                    Container(
                      width: TextSize.COROUSEL_HEIGHT,
                      child: Text(widget.meal.description == null || widget.meal.description == 'null'
                          ? ' '
                          : widget.meal.description, maxLines: 1,) ,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        widget.meal.price.toString() + widget.meal.currencySymbol,
                        style:
                            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Column(
              children: [
              FlatButton(
                onPressed: () {
                  _con.addMealToFavourite(widget.meal).then((value) {
                    setState(() {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(S.of(context).thisFoodWasAddedToFavorite),
                      ));
                    });
                  });
                },
                minWidth: TextSize.LOGO_PADDING_SIZE,
                height: TextSize.LOGO_PADDING_SIZE,
                child: Image.asset(
                  'assets/img/like.png',
                  fit: BoxFit.contain,
                ),
              ),
              Spacer(),
              FlatButton(
                onPressed: () {
                  openMealCustomisationPage();
                },
                minWidth: TextSize.BUTTON,
                height: TextSize.BUTTON,
                child: Image.asset(
                  'assets/img/cart.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ))
        ],
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
          print("itemdetails${response.body}");
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
