import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/pages/view_cart_page.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../constants.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../helpers/custom_trace.dart';
import '../models/Meals.dart';
import '../models/choice.dart';
import '../models/item_details.dart';
import '../models/meal_customisation_arguments.dart';
import '../models/meal_details.dart';
import '../models/recipe.dart';
import '../repository/meals_repository.dart';
import '../models/DiningRestaurantResponse.dart';
import 'meal_customisation_page.dart';

class ItemCustomisationWidget extends StatefulWidget {
  final MealCustomizationArguments mealCustomizationArguments;
  PageBar pageBar;
  final int restaurantId;
  final Data restaurant;

  ItemCustomisationWidget(this.mealCustomizationArguments,
      {Key key, this.pageBar, this.restaurantId, this.restaurant})
      : super(key: key);

  @override
  _ItemCustomisationWidgetState createState() =>
      _ItemCustomisationWidgetState();
}

class _ItemCustomisationWidgetState extends StateMVC<ItemCustomisationWidget> {
  int quantityCalculation;
  List<Meal> preferredMealsList;
  RestaurantController _con;
  ItemDetails itemDetails;
  int cartCount;
  int groupValue;
  int notificationsCount;
  var startCount = 1;
  bool itemadd = false;
  int totalMealCount = 1;
  _ItemCustomisationWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

    print(
        "jkljkljkljkjklj---${widget.mealCustomizationArguments.meal.toJson()}");

    /// register
    ///
    FBroadcast.instance().register(Constants.cartCount, (value, callback) {
      /// get data
      cartCount = value;
      setState(() {});
    });

    if (widget.mealCustomizationArguments.meal.count != null &&
        widget.mealCustomizationArguments.meal.count.isNotEmpty) {
      totalMealCount = int.parse(widget.mealCustomizationArguments.meal.count);
    }
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
    getItemsDetails();
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  void getItemsDetails() async {
    getItemDetails(widget.mealCustomizationArguments.meal.id.toString())
        .then((response) {
      if (response.statusCode == 200) {
        var itemDetails = ItemDetails.fromJson(json.decode(response.body));
        this.itemDetails = itemDetails;
        print("Item : $itemDetails");
        updatePreSelectedData();
        setState(() {});
      } else if (response.statusCode == 202) {
        _con.scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text(response.body)));
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
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => NotificationListingWidget()),
//                  );
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

  _buildItems(List<Recipe> recipes, List<ItemList> itemsList) {
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
    if (recipes != null && recipes.length > 0) {
      for (Recipe recipe in recipes) {
        columnContent.add(
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
//                Checkbox(
//                    value: recipe.isSelected,
//                    activeColor: Colors.deepPurpleAccent ,
//                    onChanged: (bool value) {
//                      setState(() {
//                        recipe.isSelected = value;
//                        if (value) {
//                          recipe.quantity = 1;
//                        } else {
//                          recipe.quantity = 0;
//                        }
//                        setState(() {});
//                      });
//                    }),
                Text(
                  recipe.name,
                  style: TextStyle(fontSize: 12),
                ),
                Spacer(
                  flex: 1,
                ),
                Row(
                  children: [
                    new IconButton(
                      icon: new Icon(
                        Icons.remove_circle_outline,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        if (recipe.quantity > 0) {
                          recipe.quantity--;
                          if (recipe.quantity == 0) {
                            recipe.isSelected = false;
                          }
                          setState(() {});
                        }
                      },
                      iconSize: 14,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    new SizedBox(
                      width: 45,
                      child: new Text(
                        (recipe.quantity == 0 || recipe.quantity == null)
                            ? 'None'
                            : recipe.quantity == 1
                                ? 'Normal'
                                : '${recipe.quantity - 1} Extra',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(
                        Icons.add_circle_outline,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        recipe.quantity++;
                        recipe.isSelected = true;
                        setState(() {});
                      },
                      iconSize: 14,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: TextSize.PADDING_SIZE2),
                  width: TextSize.TOP_PADDING,
                  child: Text(
                    recipe.price.toString() +
                        itemDetails.response.data.first.currencySymbol,
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

    if (itemsList != null && itemsList.length > 0) {
      for (ItemList content in itemsList) {
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
                              fontSize: 16,
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

                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        content.maxChoice == 1
                            ?  Radio(
                            value: 0,
                            activeColor: Colors.deepPurpleAccent,
                            groupValue:  content.choices[i].isSelected!=null && content.choices[i].isSelected ? 0:1,
                            toggleable: true,
                            onChanged: (value) {
                              print(i);
                              if(value==0){
                                print("bjkbjkbbb--$value", );
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
                              }
                              else{
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
                                value: c.isSelected,
                                activeColor: Colors.deepPurpleAccent,
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
                                    print("hello----${content.choices}");
                                    setState(() {});
                                  });
                                }),
                        Text(
                          c.name ?? '',
                          style: TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text(
                          c.price.toString() +
                              itemDetails.response.data.first.currencySymbol,
                          style: TextStyle(fontSize: 15),
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

  bool isPressed = false;

  Widget getDataWidget() {
    if (itemDetails == null) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        // child: Text("Loading meal information"),
        child: CircularLoadingWidget(height: 50),
      );
    }
    if (itemDetails.response == null || itemDetails.response.data == null) {
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
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    child: Text(
                      (itemDetails.response.data == null ||
                              itemDetails.response.data.first.name == null)
                          ? "Meal"
                          : itemDetails.response.data.first.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat-Regular',
                        //fontSize: double.minPositive,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
//                Spacer(),
                //  SizedBox(
                // width: 113 ,
                Expanded(
                    flex: 1,
                    child: FittedBox(
                      child: Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: TextSize.PADDING),
                              child: IconButton(
                                iconSize: 18,
                                color: null,
                                icon: itemDetails.response.data.first.fvrt == 0
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
                                      .addMealToFavourite(widget
                                          .mealCustomizationArguments.meal)
                                      .then((value) {
                                    setState(() {
                                      _con.scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(S
                                            .of(context)
                                            .thisFoodWasAddedToFavorite),
                                      ));
                                      isPressed = true;
                                    });
                                  });
                                },
                              )),
                          IconButton(
                              icon: Image.asset(
                                "assets/img/delate.png",
                              ),
                              iconSize: 12,
                              color: null,
                              onPressed: () {
                                widget.pageBar.showRestaurant(widget
                                    .mealCustomizationArguments
                                    .meal
                                    .restaurantId);
                              }),
                        ],
                      ),
                    ))
                //)
              ],
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
          Text(itemDetails.response.data.first.description == null ||
                  itemDetails.response.data.first.description == 'null'
              ? ''
              : itemDetails.response.data.first.description),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Text(
              'Item customizer',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat-Regular',
                fontSize: 24,
              ),
            ),
          ),
          (itemDetails.response.data.first.recipe == null ||
                      itemDetails.response.data.first.recipe.isEmpty) &&
                  (itemDetails.response.data.first.list == null ||
                      itemDetails.response.data.first.list.isEmpty)
              ? Text('No items')
              : Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: _buildItems(
                      itemDetails.response.data.first.recipe,
                      itemDetails.response.data.first.list,
                    ),
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
                  'Item Price\n(Excluding taxes)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  getTotalItemPrice().toStringAsFixed(2) +
                      itemDetails.response.data.first.currencySymbol,
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
                          print("meraa$totalMealCount");
                          if (isRequiredFieldsSelected(
                              itemDetails.response.data.first)) {
                            _con
                                .addItemToCart(
                                    context,
                                    _con.scaffoldKey,
                                    widget.mealCustomizationArguments
                                                .foodDetail !=
                                            null
                                        ? widget.mealCustomizationArguments
                                            .foodDetail.cartId
                                        : 0,
                                    widget.mealCustomizationArguments.meal.id,
                                    getFinalItemPrice().toString(),
                                    //widget.mealCustomizationArguments.meal.price,
                                    itemDetails.response.data.first.recipe,
                                    itemDetails.response.data.first.list,
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
                                      print(
                                          "kjehga$widget.mealCustomizationArguments");

                                      _con
                                          .addItemToCart(
                                              context,
                                              _con.scaffoldKey,
                                              widget.mealCustomizationArguments
                                                          .foodDetail !=
                                                      null
                                                  ? widget
                                                      .mealCustomizationArguments
                                                      .foodDetail
                                                      .cartId
                                                  : 0,
                                              widget.mealCustomizationArguments
                                                  .meal.id,
                                              widget.mealCustomizationArguments
                                                  .meal.price,
                                              itemDetails
                                                  .response.data.first.recipe,
                                              itemDetails
                                                  .response.data.first.list,
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
                                        print("meracode$totalMealCount");
                                      });
                                      print(
                                          "mera$widget.mealCustomizationArguments");
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
                      // itemadd == false ? startCount.toString() :
                      totalMealCount.toString(),
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

  bool isRequiredFieldsSelected(ItemInfo mealInfo) {
    if (mealInfo != null && mealInfo.list != null && mealInfo.list.isNotEmpty) {
      for (var list in mealInfo.list) {
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

    return true;
  }

  int getItemsCount(ItemInfo data) {
    int count = 0;
    if (data.recipe != null && data.recipe.isNotEmpty) {
      count += data.recipe.length;
    }
    if (data.list != null && data.list.isNotEmpty) {
      count += data.list.length;
    }
    return count;
  }

  double getTotalItemPrice() {
    double totalItemPrice = 0;
    totalItemPrice += getTotalRecipesPrice();
    totalItemPrice += getTotalChoicesPrice();
    totalItemPrice += itemDetails.response.data.first.price;
    totalItemPrice = totalItemPrice * totalMealCount;
    return totalItemPrice;
  }

  double getFinalItemPrice() {
    double FinalItemPrice = 0;
    FinalItemPrice += getTotalRecipesPrice();
    FinalItemPrice += getTotalChoicesPrice();
    FinalItemPrice += itemDetails.response.data.first.price;
    return FinalItemPrice;
  }

  double getTotalRecipesPrice() {
    double recipesPrice = 0;
    ItemInfo mealInfo = itemDetails.response.data.first;
    if (mealInfo != null &&
        mealInfo.recipe != null &&
        mealInfo.recipe.isNotEmpty) {
      for (var recipe in mealInfo.recipe) {
        if (recipe.isSelected) {
          recipesPrice += recipe.price * (recipe.quantity - 1);
        }
      }
    }
    return recipesPrice;
  }

  double doubleConvert(dynamic value) {
    if (value != null && value.toString() != "") {
      return double.parse(value.toString());
    } else {
      return 0.0;
    }
  }

  dynamic getTotalChoicesPrice() {
    dynamic choicesPrice = 0;
    ItemInfo mealInfo = itemDetails.response.data.first;
    if (mealInfo != null && mealInfo.list != null && mealInfo.list.isNotEmpty) {
      for (var list in mealInfo.list) {
        for (var choice in list.choices) {
          if (choice.isSelected) {
            choicesPrice += (doubleConvert(choice.price));
          }
        }
      }
    }
    return choicesPrice;
  }

  void updatePreSelectedData() {
    var recipes = itemDetails.response.data.first.recipe;
    var itemsList = itemDetails.response.data.first.list;
    if (recipes != null && recipes.length > 0) {
      for (Recipe itemRecipe in recipes) {
        if (widget.mealCustomizationArguments.foodDetail != null &&
            widget.mealCustomizationArguments.foodDetail.recipe != null &&
            widget.mealCustomizationArguments.foodDetail.recipe.length > 0) {
          for (var selectedRecipe
              in widget.mealCustomizationArguments.foodDetail.recipe) {
            for (var recipe in selectedRecipe.recipe) {
              if (itemRecipe.recipeId == recipe.recipeId) {
                itemRecipe.isSelected = true;
                itemRecipe.quantity = recipe.quantity;
              }
            }
          }
        }
      }
    }

    if (itemsList != null && itemsList.length > 0) {
      for (ItemList content in itemsList) {
        String listName = content.listName;
        for (var c in content.choices) {
          if (widget.mealCustomizationArguments.foodDetail != null &&
              widget.mealCustomizationArguments.foodDetail.lists != null &&
              widget.mealCustomizationArguments.foodDetail.lists.length > 0) {
            for (var selectedList
                in widget.mealCustomizationArguments.foodDetail.lists) {
              if (selectedList.list_name == listName) {
                if (selectedList.list != null && selectedList.list.length > 0) {
                  for (var list in selectedList.list) {
                    if (c.name == list.name) {
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
}
