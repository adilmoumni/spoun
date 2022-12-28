import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/custom_trace.dart';
import '../models/Meals.dart';
import '../models/add_on.dart';
import '../models/choice.dart';
import '../models/meal_customisation_arguments.dart';
import '../models/meal_details.dart';
import '../models/recipe.dart';
import '../repository/meals_repository.dart';
import '../models/DiningRestaurantResponse.dart';

class MealCustomisationWidget extends StatefulWidget {
  final MealCustomizationArguments mealCustomizationArguments;
  PageBar pageBar;
  final int restaurantId;
  final Data restaurant;

  MealCustomisationWidget(this.mealCustomizationArguments,
      {Key key, this.pageBar, this.restaurantId, this.restaurant})
      : super(key: key);

  @override
  _MealCustomisationWidgetState createState() =>
      _MealCustomisationWidgetState();
}

class _MealCustomisationWidgetState extends StateMVC<MealCustomisationWidget> {
  List<Meal> preferredMealsList;
  RestaurantController _con;
  MealDetails mealDetails;
  int cartCount;
  int notificationsCount;
  int groupValue;
  bool itemadd = false;
  _MealCustomisationWidgetState() : super(RestaurantController()) {
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

    setState(() {
      totalMealCount = widget.mealCustomizationArguments.foodDetail != null
          ? widget.mealCustomizationArguments.foodDetail.quantity
          : 1;
    });

    CommonMethods.getCartCount();
    CommonMethods.getNotifications();
    getMealsDetails();
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  void getMealsDetails() async {
    getMealDetails(widget.mealCustomizationArguments.meal.id.toString())
        .then((response) {
      if (response.statusCode == 200) {
        var mealDetails = MealDetails.fromJson(json.decode(response.body));
        this.mealDetails = mealDetails;
        print("Meal : $mealDetails");

        updatePreSelectedData();
        setState(() {});
      } else if (response.statusCode == 202) {
        _con.scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Please try after sometime")));
      } else if (response.statusCode == 429) {
        _con.scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text("Please try after sometime")));
      } else {
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
        _con.scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(response.body)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          widget.pageBar.showRestaurant(
              widget.mealCustomizationArguments.meal.restaurantId);
        },
        child: Scaffold(
            key: _con.scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding:
                      EdgeInsets.only(right: 0, left: TextSize.PADDING_SIZE),
                  child: InkWell(
                    onTap: () {
//                  Navigator.of(context).pushNamed('/Pages', arguments: 0);
                      widget.pageBar.showRestaurant(
                          widget.mealCustomizationArguments.meal.restaurantId);
                    },
                    child: Padding(
                        padding: EdgeInsets.only(
                            right: TextSize.PRODUCTADD_CONTAINER_WIDTH,
                            left: TextSize.PADDING_SIZE),
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
                        padding: const EdgeInsets.only(right: 12, left: 0),
                        child: IconButton(
                          icon: notificationsCount != null &&
                                  notificationsCount > 0
                              ? Badge(
                                  badgeContent: Text(
                                    notificationsCount.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  child: Icon(Icons.notifications,
                                      color: Colors.deepPurpleAccent, size: 28),
                                  badgeColor: Colors.deepPurpleAccent,
                                )
                              : Icon(Icons.notifications,
                                  color: Colors.deepPurpleAccent, size: 28),
                        )),
                  ),
                ),
              ],
            ),
            body: getDataWidget()));
  }

  Widget _buildAddonItem(AddOn item) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
                value: item.isSelected,
                activeColor: Colors.deepPurpleAccent,
                onChanged: (bool val) {
                  setState(() {
                    item.isSelected = val;
                    setState(() {});
                  });
                }),
            new Text(
              (item.name),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Spacer(),
            new Text(
              (item.price.toString() +
                  mealDetails.response.mealsInfo.first.currencySymbol),
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.end,
            )
          ]),
    );
  }

  _buildExpandableRecipe(Items item) {
    List<Widget> columnContent = [];
    columnContent.add(Container(
      width: double.infinity,
      color: Colors.white,
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Text(
//            'Recipe',
//            style: TextStyle(
//              color: Colors.black,
//              fontFamily: 'Montserrat-Regular',
//              fontSize: 16,
//            ),
//          ),
//        )
    ));
    if (item.recipe != null && item.recipe.isNotEmpty) {
      for (var itemRecipe in item.recipe) {
        columnContent.add(
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Checkbox(
//                    value: itemRecipe.isSelected,
//                    activeColor: Colors.deepPurpleAccent,
//                    onChanged: (bool value) {
//                      setState(() {
//                        itemRecipe.isSelected = value;
//                        if (value) {
//                          itemRecipe.quantity = 1;
//                        } else {
//                          itemRecipe.quantity = 0;
//                        }
//                        setState(() {});
//                      });
//                    }),
                Padding(
                  padding: EdgeInsets.only(left: 40),
                  child: Text(
                    itemRecipe.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    new IconButton(
                      icon: new Icon(
                        Icons.remove_circle_outline,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        if (itemRecipe.quantity > 0) {
                          itemRecipe.quantity--;
                          if (itemRecipe.quantity == 1) {
                            itemRecipe.isSelected = false;
                          }
                          setState(() {});
                        }
                      },
                      iconSize: 20,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    new SizedBox(
                      width: 45,
                      child: new Text(
                        (itemRecipe.quantity == 0 ||
                                itemRecipe.quantity == null)
                            ? 'None'
                            : itemRecipe.quantity == 1
                                ? 'Normal'
                                : '${itemRecipe.quantity - 1} Extra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(
                        Icons.add_circle_outline,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        itemRecipe.quantity++;
                        itemRecipe.isSelected = true;
                        setState(() {});
                      },
                      iconSize: 20,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 10),
                  width: TextSize.TOP_PADDING,
                  child: Text(
                    itemRecipe.price.toString() +
                        mealDetails.response.mealsInfo.first.currencySymbol,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    if (item.list != null && item.list.isNotEmpty) {
      for (ItemList content in item.list) {
        columnContent.add(Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: content.required == 1
                    ? Row(
                        children: [
                          Text(
                            content.listName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '(Required - Max ' +
                                content.maxChoice.toString() +
                                ")",
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Montserrat-Regular',
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        ],
                      )
                    : Text(
                        content.listName,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat-Regular',
                          fontSize: 16,
                        ),
                      ))));
        columnContent.add(
          Container(
              color: Colors.white,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: content.choices == null ? 0 : content.choices.length,
                itemBuilder: (context, i) {
                  Choice c = content.choices[i];
                  print("bkjbbjbkjbkjbjkb, ${content.choices[i].toJson()}");
                  print("bkjbbjbkjbkjbjkb, ${content.choices.length}");
                  print("bkjbbjbkjbkjbjkb, ${i}");
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        content.maxChoice == 1
                            ? Radio(
                                value: 0,
                                activeColor: Colors.deepPurpleAccent,
                                groupValue:
                                    content.choices[i].isSelected != null &&
                                            content.choices[i].isSelected
                                        ? 0
                                        : 1,
                                toggleable: true,
                                onChanged: (value) {
                                  print(i);
                                  if (value == 0) {
                                    print(
                                      "bjkbjkbbb--$value",
                                    );
                                    setState(() {
                                      groupValue = value;
                                      c.isSelected = true;

                                      int totalCount = 0;
                                      for (var choice in content.choices) {
                                        print({"herechoice----${choice.name}"});
                                        print("simmy--$i");
                                        if (choice.isSelected) {
                                          totalCount++;
                                          for (var i = 0;
                                              i < content.choices.length;
                                              i++) {
                                            if (i != value) {
                                              choice.isSelected = false;
                                            }
                                          }
                                          c.isSelected = true;
                                        }
                                      }
                                      if (totalCount > content.maxChoice) {
                                        totalCount--;
                                        c.isSelected = true;
                                      }
                                      print("error-----$groupValue");
                                    });
                                  } else {
                                    setState(() {
                                      groupValue = value;
                                      c.isSelected = false;

                                      int totalCount = 0;
                                      for (var choice in content.choices) {
                                        print({"herechoice----${choice.name}"});
                                        print("simmy--$i");
                                        if (choice.isSelected) {
                                          totalCount++;
                                          for (var i = 0;
                                              i < content.choices.length;
                                              i++) {
                                            if (i != value) {
                                              choice.isSelected = true;
                                            }
                                          }
                                          c.isSelected = false;
                                        }
                                      }
                                      if (totalCount > content.maxChoice) {
                                        totalCount--;
                                        c.isSelected = false;
                                      }
                                      print("error-----$groupValue");
                                    });
                                  }
                                  setState(() {});
                                })
                            : Checkbox(
                                activeColor: Colors.deepPurpleAccent,
                                value: c.isSelected,
                                onChanged: (bool value) {
                                  setState(() {
                                    c.isSelected = value;
                                    int totalCount = 0;
                                    for (var choice in content.choices) {
                                      if (choice.isSelected) {
                                        totalCount++;
                                      }
                                    }
                                    if (totalCount > content.maxChoice) {
                                      c.isSelected = false;
                                      Flushbar(
                                        message: "Can select only " +
                                            content.maxChoice.toString() +
                                            "  choices from " +
                                            content.listName,
                                        duration: Duration(seconds: 3),
                                      ).show(context);
                                    }
                                    setState(() {});
                                  });
                                }),
                        Text(
                          c.name ?? '',
                          style: TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          c.price.toString() +
                              mealDetails
                                  .response.mealsInfo.first.currencySymbol,
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  );
                },
              )),
        );
      }
    }
    return columnContent;
  }

  int totalMealCount = 1;
  bool isPressed = false;
  Widget _myRadioButton({String title, int value, Function(int) onChanged}) {
    return Radio(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }

  Widget getDataWidget() {
    if (mealDetails == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        // child: Text("Loading meal information"),
        child: CircularLoadingWidget(height: 50),
      );
    }
    if (mealDetails.response == null ||
        mealDetails.response.mealsInfo == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text('Meal information not available'),
      );
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: TextSize.BUTTON),
            title: Row(
              children: [
                Container(
                  width: TextSize.MEMBESHIP_WIDTH_BOX,
                  child: Text(
                    (mealDetails.response.mealsInfo == null ||
                            mealDetails.response.mealsInfo.first.name == null)
                        ? "Meal"
                        : mealDetails.response.mealsInfo.first.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Montserrat-Regular',
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: TextSize.PADDING),
                  child: IconButton(
                    iconSize: 18,
                    color: null,
                    icon: mealDetails.response.mealsInfo.first.fvrt == 0
                        ? Icon(Icons.favorite_rounded,
                            color: (isPressed)
                                ? Colors.deepPurpleAccent
                                : Colors.black26)
                        : Icon(Icons.favorite_rounded,
                            color: (isPressed)
                                ? Colors.deepPurpleAccent
                                : Colors.deepPurpleAccent),
                    onPressed: () {
                      _con
                          .addMealToFavourite(
                              widget.mealCustomizationArguments.meal)
                          .then((value) {
                        setState(() {
                          _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text(S.of(context).thisFoodWasAddedToFavorite),
                          ));
                          isPressed = true;
                        });
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 0, right: 0),
                  child: IconButton(
                      icon: Image.asset(
                        "assets/img/delate.png",
                      ),
                      iconSize: 8,
                      color: null,
                      onPressed: () {
                        widget.pageBar.showRestaurant(widget
                            .mealCustomizationArguments.meal.restaurantId);
                      }),
                )
              ],
            ),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Description',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Montserrat-Regular',
                fontSize: 18,
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                mealDetails.response.mealsInfo.first.foodDescription == null ||
                        mealDetails.response.mealsInfo.first.foodDescription ==
                            "null" ||
                        mealDetails
                            .response.mealsInfo.first.foodDescription.isEmpty
                    ? ' '
                    : mealDetails.response.mealsInfo.first.foodDescription,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Meal customizer',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Regular',
                fontSize: 24,
              ),
            ),
          ),
          mealDetails.response.mealsInfo.first.items == null ||
                  mealDetails.response.mealsInfo.first.items.isEmpty
              ? Text('No items')
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: mealDetails.response.mealsInfo.first.items.length,
                  itemBuilder: (context, i) {
                    return Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                            color: const Color(0xFF6246E7).withOpacity(0.4),
                            child: new ExpansionTile(
                                initiallyExpanded: false,
                                title: new Text(
                                  mealDetails
                                      .response.mealsInfo.first.items[i].name,
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                    color: const Color(0xFF736F83),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: <Widget>[
                                  new Column(
                                    children: _buildExpandableRecipe(
                                      mealDetails
                                          .response.mealsInfo.first.items[i],
                                    ),
                                  ),
                                ])));
                  },
                ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Add on',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Regular',
                fontSize: 24,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: mealDetails.response.mealsInfo.first.addOn == null ||
                    mealDetails.response.mealsInfo.first.addOn.isEmpty
                ? Text('No Add ons')
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        mealDetails.response.mealsInfo.first.addOn.length,
                    itemBuilder: (context, i) {
                      return _buildAddonItem(
                          mealDetails.response.mealsInfo.first.addOn[i]);
                    },
                  ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meal Price\n(Excluding taxes)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getFinalItemPrice().toStringAsFixed(2) +
                      mealDetails.response.mealsInfo.first.currencySymbol,
                  //getTotalMealPrice().toString() + ' AED',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 60, right: 60, bottom: 20),
            child: FittedBox(
              fit: BoxFit.contain,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: const Color(0xFF6244E8))),
                onPressed: () {},
                color: const Color(0xFF6244E8),
                textColor: Colors.white,
                child: Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          if (isRequiredFieldsSelected(
                              mealDetails.response.mealsInfo.first)) {
                            _con
                                .addMealToCart(
                                    context,
                                    _con.scaffoldKey,
                                    widget.mealCustomizationArguments
                                                .foodDetail !=
                                            null
                                        ? widget.mealCustomizationArguments
                                            .foodDetail.cartId
                                        : 0,
                                    widget.mealCustomizationArguments.meal.id,
                                    getTotalMealPrice().toString(),
                                    //getFinalItemPrice().toString(),
                                    mealDetails.response.mealsInfo.first.items,
                                    mealDetails.response.mealsInfo.first.addOn,
                                    widget.mealCustomizationArguments.meal
                                        .restaurantId,
                                    totalMealCount,
                                    false)
                                .then((value) {
                              if (value != null) {
                                if (value.response.code == 200) {
                                  _con.scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(value.response.message)));
                                  setState(() => totalMealCount);
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
                                              widget.mealCustomizationArguments.foodDetail != null
                                                  ? widget
                                                      .mealCustomizationArguments
                                                      .foodDetail
                                                      .cartId
                                                  : 0,
                                              widget.mealCustomizationArguments
                                                  .meal.id,
                                              getTotalMealPrice().toString(),
                                              mealDetails.response.mealsInfo
                                                  .first.items,
                                              mealDetails.response.mealsInfo
                                                  .first.addOn,
                                              widget.mealCustomizationArguments
                                                  .meal.restaurantId,
                                              totalMealCount,
                                              true)
                                          .then((value) {
                                        _con.scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    value.response.message)));
                                        setState(() => totalMealCount);
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
                          } else {
                            _con.scaffoldKey.currentState.showSnackBar(SnackBar(
                                content:
                                    Text('Please select the required fields')));
                          }
                        },
                        child: new Text(
                          'Add to basket  ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    totalMealCount != 1
                        ? new IconButton(
                            icon: new Icon(Icons.remove),
                            onPressed: () => setState(
                                () => {totalMealCount--, itemadd = true}),
                            iconSize: 20,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            color: Colors.white,
                          )
                        : new IconButton(
                            icon: new Icon(Icons.remove),
                            onPressed: () {},
                            iconSize: 20,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            color: Colors.white38,
                          ),
                    new Text(
                      itemadd == false ? "1" : totalMealCount.toString(),
                      style: TextStyle(color: Colors.white
//                      const Color(0xFF736F83)
                          ),
                    ),
                    new IconButton(
                      icon: new Icon(Icons.add),
                      onPressed: () =>
                          setState(() => {totalMealCount++, itemadd = true}),
                      iconSize: 20,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isRequiredFieldsSelected(MealInfo mealInfo) {
    if (mealInfo != null &&
        mealInfo.items != null &&
        mealInfo.items.isNotEmpty) {
      for (var item in mealInfo.items) {
        if (item != null && item.list != null && item.list.isNotEmpty) {
          for (var list in item.list) {
            if (list.required == 1) {
              int selectedChoiceCount = 0;
              for (var choice in list.choices) {
                if (choice.isSelected) {
                  selectedChoiceCount++;
                }
              }
              if (selectedChoiceCount == 0) {
                return false;
              }
            }
          }
        }
      }
    }
    return true;
  }

  double doubleConvert(dynamic value) {
    if (value != null && value.toString() != "") {
      return double.parse(value.toString());
    } else {
      return 0.0;
    }
  }

  double getTotalMealPrice() {
    double totalMealPrice = 0;
    totalMealPrice += getTotalAddonsPrice();
    totalMealPrice += getTotalRecipesPrice();
    totalMealPrice += getTotalChoicesPrice();
    totalMealPrice += mealDetails.response.mealsInfo.first.price;
    // totalMealPrice = totalMealPrice * totalMealCount;
    return totalMealPrice;
  }

  double getFinalItemPrice() {
    double FinalItemPrice = 0;
    FinalItemPrice += getTotalAddonsPrice();
    FinalItemPrice += getTotalRecipesPrice();
    FinalItemPrice += getTotalChoicesPrice();
    FinalItemPrice += mealDetails.response.mealsInfo.first.price;
    FinalItemPrice = FinalItemPrice * totalMealCount;
    return FinalItemPrice;
  }

  double getTotalAddonsPrice() {
    double addOnsPrice = 0;
    MealInfo mealInfo = mealDetails.response.mealsInfo.first;
    if (mealInfo != null &&
        mealInfo.addOn != null &&
        mealInfo.addOn.isNotEmpty) {
      for (var addOn in mealInfo.addOn) {
        if (addOn.isSelected) {
          addOnsPrice += addOn.price;
        }
      }
    }
    return addOnsPrice;
  }

  double getTotalRecipesPrice() {
    double recipesPrice = 0;
    MealInfo mealInfo = mealDetails.response.mealsInfo.first;
    if (mealInfo != null &&
        mealInfo.items != null &&
        mealInfo.items.isNotEmpty) {
      for (var item in mealInfo.items) {
        if (item != null && item.recipe != null && item.recipe.isNotEmpty) {
          for (var recipe in item.recipe) {
            if (recipe.isSelected) {
              //recipesPrice += recipe.price * (recipe.quantity <=1 ? 0 : recipe.quantity-1);
              recipesPrice += recipe.price * (recipe.quantity - 1);
            }
          }
        }
      }
    }
    return recipesPrice;
  }

  double getTotalChoicesPrice() {
    double choicesPrice = 0;
    MealInfo mealInfo = mealDetails.response.mealsInfo.first;
    if (mealInfo != null &&
        mealInfo.items != null &&
        mealInfo.items.isNotEmpty) {
      for (var item in mealInfo.items) {
        if (item != null && item.list != null && item.list.isNotEmpty) {
          for (var list in item.list) {
            for (var choice in list.choices) {
              if (choice.isSelected) {
                // (doubleConvert((restaurantList.foodDetail[index].price)) *
                //     restaurantList.foodDetail[index].quantity).toString(),

                choicesPrice += double.parse(choice.price.toString());
              }
            }
          }
        }
      }
    }
    return choicesPrice;
  }

  void updatePreSelectedData() {
    try {
      for (int i = 0;
          i < mealDetails.response.mealsInfo.first.items.length;
          i++) {
        var item = mealDetails.response.mealsInfo.first.items[i];
        if (item != null && item.recipe != null && item.recipe.length > 0) {
          for (Recipe itemRecipe in item.recipe) {
            if (widget.mealCustomizationArguments.foodDetail != null &&
                widget.mealCustomizationArguments.foodDetail.recipe != null &&
                widget.mealCustomizationArguments.foodDetail.recipe.length >
                    0) {
              for (var selectedRecipe
                  in widget.mealCustomizationArguments.foodDetail.recipe) {
                if (selectedRecipe.item_id == item.itemId) {
                  for (var recipe in selectedRecipe.recipe) {
                    if (recipe.recipeId == itemRecipe.recipeId) {
                      itemRecipe.isSelected = true;
                      itemRecipe.quantity = recipe.quantity;
                    }
                  }
                }
              }
            }
          }
        }

        if (item != null && item.list != null && item.list.length > 0) {
          for (ItemList content in item.list) {
            String listName = content.listName;
            for (int i = 0; i < content.choices.length; i++) {
              Choice c = content.choices[i];
              if (widget.mealCustomizationArguments.foodDetail != null &&
                  widget.mealCustomizationArguments.foodDetail.lists != null &&
                  widget.mealCustomizationArguments.foodDetail.lists.length >
                      0) {
                for (var selectedList
                    in widget.mealCustomizationArguments.foodDetail.lists) {
                  if (selectedList.list_name == listName) {
                    if (selectedList.list != null &&
                        selectedList.list.length > 0) {
                      for (var list in selectedList.list) {
                        if (c.choiceId == list.choice_id) {
                          c.isSelected = true;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      for (int i = 0;
          i < mealDetails.response.mealsInfo.first.addOn.length;
          i++) {
        var addOn = mealDetails.response.mealsInfo.first.addOn[i];
        if (widget.mealCustomizationArguments.foodDetail != null &&
            widget.mealCustomizationArguments.foodDetail.addon != null &&
            widget.mealCustomizationArguments.foodDetail.addon.length > 0) {
          for (var selectedAddOn
              in widget.mealCustomizationArguments.foodDetail.addon) {
            if (addOn.name == selectedAddOn.name) {
              addOn.isSelected = true;
            }
          }
        }
      }
    } catch (e) {
      print("error$e");
    }
    // for (int i = 0;
    // i < mealDetails.response.mealsInfo.first.addOn.length;
    // i++) {
    //   var addOn = mealDetails.response.mealsInfo.first.addOn[i];
    //   if (widget.mealCustomizationArguments.foodDetail != null &&
    //       widget.mealCustomizationArguments.foodDetail.addon != null &&
    //       widget.mealCustomizationArguments.foodDetail.addon.length > 0) {
    //     for (var selectedAddOn
    //     in widget.mealCustomizationArguments.foodDetail.addon) {
    //       if (addOn.name == selectedAddOn.name) {
    //         addOn.isSelected = true;
    //       }
    //     }
    //   }
    // }
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;
  final String text1;

  RadioModel(this.isSelected, this.buttonText, this.text, this.text1);
}
