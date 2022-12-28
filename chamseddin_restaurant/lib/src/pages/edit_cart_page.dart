import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/Meals.dart';
import '../models/edit_cart_arguments.dart';
import '../models/meal_customisation_arguments.dart';
import '../models/view_cart_response.dart';
import '../repository/meals_repository.dart';

class EditCartWidget extends StatefulWidget {
  final EditCartArguments editCartArguments;
  PageBar pageBar;

  EditCartWidget(this.editCartArguments, {Key key, this.pageBar})
      : super(key: key);

  @override
  _EditCartWidgetState createState() => _EditCartWidgetState();
}

class _EditCartWidgetState extends StateMVC<EditCartWidget> {
  String diningAreaId;
  RestaurantController _con;

  _EditCartWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  List<Meal> allMealsOfRestaurant = new List();

  void getMeals() async {
    allMealsOfRestaurant.clear();
    setState(() {});
    getAllMealsForRestaurant(null, widget.editCartArguments.restaurantId)
        .then((value) {
      for (var meal in value.response.data) {
        if (meal.restaurantId ==
            widget.editCartArguments.restaurantList.restaurantId) {
          allMealsOfRestaurant.add(meal);
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getMeals();
  }

  @override
  onRefreshCart() {
    setState(() {
      getMeals();
    });
  }

  double doubleConvert(dynamic value) {
    if (value != null && value.toString() != "") {
      print("bhbjhbbhb" + value.toString());
      return double.parse(value.toString());
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pushNamed('/Pages', arguments: 1);
        },
        child: Scaffold(
            key: _con.scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/Pages', arguments: 1),
                  icon: Icon(
                    Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios_sharp,
                    color: Colors.black26,
                  )),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
            body: getWidget()));
  }

  Widget getWidget() {
    if (allMealsOfRestaurant == null || allMealsOfRestaurant.isEmpty) {
      return Container(
        child: CircularLoadingWidget(height: 50),
        padding: EdgeInsets.symmetric(horizontal: TextSize.TEXT, vertical: 0),
      );
    }
    return Container(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 0),
        children: <Widget>[
          Center(
            child: Text('Edit Cart',
                style: TextStyle(
                    color: const Color(0xFF6244E8),
                    fontSize: TextSize.TEXT2,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
            child: Text(widget.editCartArguments.restaurantList.restaurantName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
          ),
          Container(),
          ListView.separated(

            padding: EdgeInsets.symmetric(vertical: 10),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            itemCount:
                widget.editCartArguments.restaurantList.foodDetail.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (context, index) {
              return Container(
                margin:
                    const EdgeInsets.only(left: 5, top: 0, bottom: 0, right: 5),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(

                              widget.editCartArguments.restaurantList
                                          .foodDetail[index].quantity >
                                      1
                                  ? widget.editCartArguments.restaurantList
                                          .foodDetail[index].name +
                                      " x " +
                                      widget.editCartArguments.restaurantList
                                          .foodDetail[index].quantity
                                          .toString()
                                  : widget.editCartArguments.restaurantList
                                      .foodDetail[index].name,
                              style: new TextStyle(
                                //fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6244E8),
                              ),
                            ),
                            Divider(
                              color: Colors.black26,
                            ),

                            /*widget.editCartArguments.restaurantList
                                .foodDetail[index].addon !=
                                null &&
                                widget.editCartArguments.restaurantList
                                    .foodDetail[index].addon.length >
                                    0
                                ? new Text('Customization and add-on x ' +
                                widget.editCartArguments.restaurantList
                                    .foodDetail[index].addon.length
                                    .toString())
                                : new Text('Customization'),
                            widget.editCartArguments.restaurantList
                                .foodDetail[index].lists !=
                                null &&
                                widget.editCartArguments.restaurantList
                                    .foodDetail[index].lists.length >
                                    0
                                ? new Text('Customization x ' +
                                widget.editCartArguments.restaurantList
                                    .foodDetail[index].lists.length
                                    .toString())
                                : new Text('Customization'),*/

                            new Text('Customization'),
                            widget.editCartArguments.restaurantList.foodDetail[index].lists != null &&
                                    widget.editCartArguments.restaurantList.foodDetail[index].lists.length >
                                        0
                                ? widget.editCartArguments.restaurantList.foodDetail[index].addon != null &&
                                        widget
                                                .editCartArguments
                                                .restaurantList
                                                .foodDetail[index]
                                                .addon
                                                .length >
                                            0
                                    ? new Text('Customization x ' +
                                        widget.editCartArguments.restaurantList
                                            .foodDetail[index].lists.length
                                            .toStringAsFixed(2) +
                                        ' & add-on x ' +
                                        widget.editCartArguments.restaurantList
                                            .foodDetail[index].addon.length
                                            .toStringAsFixed(2))
                                    : new Text('Customization x ' +
                                        widget.editCartArguments.restaurantList
                                            .foodDetail[index].lists.length
                                            .toStringAsFixed(2))
                                : widget.editCartArguments.restaurantList.foodDetail[index].addon != null &&
                                        widget.editCartArguments.restaurantList.foodDetail[index].addon.length > 0
                                    ? new Text('Customization & add-on x ' + widget.editCartArguments.restaurantList.foodDetail[index].addon.length.toStringAsFixed(2))
                                    : new Text('Customization')
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        (doubleConvert((widget.editCartArguments.restaurantList
                                    .foodDetail[index].price) *
                                widget.editCartArguments.restaurantList
                                    .foodDetail[index].quantity))
                            .toStringAsFixed(2),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey),
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Image.asset(
                                "assets/img/del.png",
                              ),
                              iconSize: 11,
                              color: null,
                              onPressed: () {
                                _con
                                    .removeFromCart(
                                        context,
                                        widget.editCartArguments.restaurantList
                                            .foodDetail[index].cartId
                                            .toString(),
                                        _con)
                                    .then((value) {
                                  if (value.response.code == 200) {
                                    widget.editCartArguments.restaurantList
                                        .restTotal = widget.editCartArguments
                                            .restaurantList.restTotal -
                                        (doubleConvert(((widget
                                                .editCartArguments
                                                .restaurantList
                                                .foodDetail[index]
                                                .price) *
                                            widget
                                                .editCartArguments
                                                .restaurantList
                                                .foodDetail[index]
                                                .quantity)));
                                    widget.editCartArguments.restaurantList
                                        .foodDetail
                                        .removeAt(index);

                                    //getMeals();
                                    onRefreshCart();
                                  }
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(value.response.message),
                                  ));
                                });
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.deepPurpleAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                for (var thisMeal in allMealsOfRestaurant) {
                                  if (widget.editCartArguments.restaurantList
                                          .foodDetail[index].menuId ==
                                      thisMeal.id) {
                                    openMealCustomisationPage(
                                        widget.editCartArguments.restaurantList
                                            .foodDetail[index],
                                        thisMeal,
                                        widget.editCartArguments.restaurantId);
                                    break;
                                  }
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Divider(
            color: Colors.black26,
          ),
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sous total'),
                  Text(
                    widget.editCartArguments.restaurantList.restTotal
                        .toStringAsFixed(2),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  openMealCustomisationPage(
      ViewCartFoodDetail foodDetail, Meal meal, int restaurantId) {
    MealCustomizationArguments mealCustomizationArguments =
        new MealCustomizationArguments(foodDetail, meal);
    if (meal.type == 'meal') {
//      Navigator.of(context).pushNamed('/MealCustomisationPage',
//          arguments: mealCustomizationArguments);
      widget.pageBar.mealCustomization(mealCustomizationArguments);
    } else {
//      Navigator.of(context).pushNamed('/ItemCustomisationPage',
//          arguments: mealCustomizationArguments);
      widget.pageBar.itemCustomization(mealCustomizationArguments);
    }
  }
}
