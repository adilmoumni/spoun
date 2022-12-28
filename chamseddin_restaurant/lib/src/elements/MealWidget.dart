import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/item_details.dart';
import 'package:food_delivery_app/src/models/meal_details.dart';
import 'package:food_delivery_app/src/models/view_cart_response.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../TextSize.dart';
import '../controllers/restaurant_controller.dart';
import '../models/Meals.dart';
import '../models/meal_customisation_arguments.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';

class MealWidget extends StatefulWidget {
  final Meal meal;
  final int restaurantId;
  final BuildContext context;
  PageBar pageBar;

  MealWidget(this.context, this.meal, this.restaurantId,
      {Key key, this.pageBar})
      : super(key: key);

  @override
  _MealWidgetState createState() => _MealWidgetState();
}

class _MealWidgetState extends StateMVC<MealWidget> {
  RestaurantController _con;
  ViewCartResponse viewCartResponse;

  _MealWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    getCart();
  }

  void getCart() {
    _con.getCart().then((response) {
      this.viewCartResponse = response;
      setState(() {});
    });
  }

  Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
  }

  var size, height, width;
  Widget build(BuildContext c) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return GestureDetector(
      onTap: () {
        print("pressed");
        openMealCustomisationPage(0);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: height/4,
          width: width / 0.25,
          // margin: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 20),
          decoration: BoxDecoration(
            // color:Colors.red,
            color: Theme.of(widget.context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(widget.context).focusColor.withOpacity(0.1),
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
                      width: TextSize.TOP,
                      height: TextSize.TOP,
                      fit: BoxFit.cover,
                      imageUrl: widget.meal.imageName == null
                          ? "http://chamseddinprod.n1.iworklab.com/images/restaurant_image/rest1.jpeg"
                          : widget.meal.imageName,
                      placeholder: (context, url) =>
                          CircularLoadingWidget(height: 50),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    )),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          widget.meal.flag == null || widget.meal.flag == 'null'
                              ? ' '
                              : "   " + widget.meal.flag + "   ",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.bold,
                            backgroundColor: widget.meal.flagColor == null
                                ? Colors.white
                                : hexToColor(widget.meal.flagColor),
                          ),
                        ),
                      ),
                      Text(widget.meal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: TextSize.BUTTON_TEXT,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6244E8),
                              fontFamily: 'Montserrat-Bold')),
                      Text(
                        widget.meal.description == null ||
                                widget.meal.description == 'null'
                            ? ' '
                            : widget.meal.description,
                        maxLines: 2,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.meal.price.toString() +
                                  widget.meal.currencySymbol,
                              style: TextStyle(
                                  fontSize: TextSize.CVV_PADDING_SIZE,
                                  fontWeight: FontWeight.bold),
                            ),
                            // FlatButton(
                            //   onPressed: () {
                            //
                            //   },
                            //   minWidth: 20,
                            //   height: 20,
                            //   child: Image.asset(
                            //     'assets/img/cart.png',
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            getQuantity()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   openMealCustomisationPage(int cartId) {
//     // var foodItem;
//        // var cartId;
//     // if (viewCartResponse.response.data != null &&
//     //     viewCartResponse.response.data.restaurantList != null) {
//     //   for (var restaurant in viewCartResponse.response.data.restaurantList) {
//     //     if (restaurant.restaurantId == widget.restaurantId) {
//     //       for (var foodDetail in restaurant.foodDetail) {
//     //         if (foodDetail.menuId == widget.meal.id) {
//     //           foodItem = foodDetail;
//     //           // cartId = foodDetail.cartId;
//     //         }
//     //       }
//     //     }
//     //   }
//     // }
//     MealCustomizationArguments mealCustomizationArguments =
//         new MealCustomizationArguments(foodItem, widget.meal);
//     if (widget.meal.type == 'meal') {
//       getMealDetails(widget.meal.id.toString()).then((response) {
//         if (response.statusCode == 200) {
//           print("DONE: 172");
//           print("${response.body}");
//           var mealDetails = MealDetails.fromJson(json.decode(response.body));
//
//           if (!CommonMethods.isMealEmpty(mealDetails)) {
// //            Navigator.of(widget.context).pushNamed('/MealCustomisationPage',
// //                arguments: mealCustomizationArguments);
//             widget.pageBar.mealCustomization(mealCustomizationArguments);
//           } else {
//             print("DONE: 178");
//             _con
//                 .addMealToCart(
//                     widget.context,
//                     _con.scaffoldKey,
//                     cartId,
//                     widget.meal.id,
//                     widget.meal.price,
//                     null,
//                     null,
//                     widget.meal.restaurantId,
//                     1,
//                     false)
//                 .then((value) {
//               print("DONE: 191");
//               if (value != null) {
//                 if (value.response.code == 200) {
//                   Scaffold.of(widget.context).showSnackBar(
//                       SnackBar(content: Text(value.response.message)));
//                   print("DONE: 196 ${value.response.message}");
//                   getCart();
//                 } else if (value.response.code == 202) {
//                   Widget cancelButton = FlatButton(
//                     child: Text("Cancel"),
//                     onPressed: () {
//                       Navigator.pop(widget.context);
//                     },
//                   );
//                   Widget continueButton = FlatButton(
//                     child: Text("Yes"),
//                     onPressed: () {
//                       Navigator.pop(widget.context);
//                       _con
//                           .addMealToCart(
//                               widget.context,
//                               _con.scaffoldKey,
//                               cartId,
//                               widget.meal.id,
//                               null,
//                               null,
//                               null,
//                               widget.meal.restaurantId,
//                               1,
//                               true)
//                           .then((value) {
//                         Scaffold.of(widget.context).showSnackBar(
//                             SnackBar(content: Text(value.response.message)));
//                       });
//                     },
//                   );
//
//                   // set up the AlertDialog
//                   AlertDialog alert = AlertDialog(
//                     title: Text('Reset Cart'),
//                     content: Text(value.response.message),
//                     actions: [
//                       cancelButton,
//                       continueButton,
//                     ],
//                   );
//
//                   // show the dialog
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return alert;
//                     },
//                   );
//                 }
//               }
//             });
//           }
//         } else if (response.statusCode == 202) {
//
//           Scaffold.of(widget.context)
//               .showSnackBar(SnackBar(content: Text(response.body)));
//         } else {
//           print(CustomTrace(StackTrace.current, message: response.body)
//               .toString());
//           Scaffold.of(widget.context)
//               .showSnackBar(SnackBar(content: Text(response.body)));
//         }
//       });
//     } else {
//       getItemDetails(widget.meal.id.toString()).then((response) {
//         if (response.statusCode == 200) {
//           print("DONE: 265 ${widget.meal.id.toString()}");
//           var itemDetails = ItemDetails.fromJson(json.decode(response.body));
//           if (!CommonMethods.isItemEmpty(itemDetails)) {
//             print("DONE: 268");
// //            Navigator.of(widget.context).pushNamed('/ItemCustomisationPage',
// //                arguments: mealCustomizationArguments);
//             int count = 0;
//             int cartId = 0;
//             var foodDetails;
//             if (viewCartResponse.response.data != null &&
//                 viewCartResponse.response.data.restaurantList != null) {
//               for (var restaurant
//                   in viewCartResponse.response.data.restaurantList) {
//                 if (restaurant.restaurantId == widget.restaurantId) {
//                   for (var foodDetail in restaurant.foodDetail) {
//                     if (foodDetail.menuId == widget.meal.id) {
//                       foodDetail = foodDetail;
//                       count = foodDetail.quantity;
//                       cartId = foodDetail.cartId;
//                     }
//                   }
//                 }
//               }
//             }
//             widget.pageBar.itemCustomization(mealCustomizationArguments);
//           } else {
//             print("DONE: 273");
//             _con
//                 .addItemToCart(
//                     widget.context,
//                     _con.scaffoldKey,
//                     0,
//                     widget.meal.id,
//                     widget.meal.price,
//                     null,
//                     null,
//                     widget.meal.restaurantId,
//                     1,
//                     false)
//                 .then((value) {
//               if (value != null) {
//                 if (value.response.code == 200) {
//                   Scaffold.of(widget.context).showSnackBar(
//                       SnackBar(content: Text(value.response.message)));
//                   getCart();
//                 } else if (value.response.code == 202) {
//                   Widget cancelButton = FlatButton(
//                     child: Text("Cancel"),
//                     onPressed: () {
//                       Navigator.pop(widget.context);
//                     },
//                   );
//                   Widget continueButton = FlatButton(
//                     child: Text("Yes"),
//                     onPressed: () {
//                       Navigator.pop(widget.context);
//                       _con
//                           .addItemToCart(
//                               widget.context,
//                               _con.scaffoldKey,
//                               0,
//                               widget.meal.id,
//                               widget.meal.price,
//                               null,
//                               null,
//                               widget.meal.restaurantId,
//                               1,
//                               true)
//                           .then((value) {
//                         Scaffold.of(widget.context).showSnackBar(
//                             SnackBar(content: Text(value.response.message)));
//                       });
//                     },
//                   );
//
//                   // set up the AlertDialog
//                   AlertDialog alert = AlertDialog(
//                     title: Text('Reset Cart'),
//                     content: Text(value.response.message),
//                     actions: [
//                       cancelButton,
//                       continueButton,
//                     ],
//                   );
//
//                   // show the dialog
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return alert;
//                     },
//                   );
//                 }
//               }
//             });
//           }
//         } else if (response.statusCode == 202) {
//           Scaffold.of(widget.context)
//               .showSnackBar(SnackBar(content: Text(response.body)));
//         } else {
//           print(CustomTrace(StackTrace.current, message: response.body)
//               .toString());
//           Scaffold.of(widget.context)
//               .showSnackBar(SnackBar(content: Text(response.body)));
//         }
//       });
//     }
//   }


  openMealCustomisationPage(int cartId) {
    MealCustomizationArguments mealCustomizationArguments =
    new MealCustomizationArguments(null, widget.meal);
    if (widget.meal.type == 'meal') {
      getMealDetails(widget.meal.id.toString()).then((response) {
        if (response.statusCode == 200) {
          print("DONE: 172");
          print("${response.body}");
          var mealDetails = MealDetails.fromJson(json.decode(response.body));

          if (!CommonMethods.isMealEmpty(mealDetails)) {
//            Navigator.of(widget.context).pushNamed('/MealCustomisationPage',
//                arguments: mealCustomizationArguments);
            widget.pageBar.mealCustomization(mealCustomizationArguments);
          } else {
            print("DONE: 178");
            _con
                .addMealToCart(
                widget.context,
                _con.scaffoldKey,
                cartId,
                widget.meal.id,
                widget.meal.price,
                null,
                null,
                widget.meal.restaurantId,
                1,
                false)
                .then((value) {
              print("DONE: 191");
              if (value != null) {
                if (value.response.code == 200) {
                  Scaffold.of(widget.context).showSnackBar(
                      SnackBar(content: Text(value.response.message)));
                  print("DONE: 196 ${value.response.message}");
                  getCart();
                } else if (value.response.code == 202) {
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(widget.context);
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(widget.context);
                      _con
                          .addMealToCart(
                          widget.context,
                          _con.scaffoldKey,
                          cartId,
                          widget.meal.id,
                          null,
                          null,
                          null,
                          widget.meal.restaurantId,
                          1,
                          true)
                          .then((value) {
                        Scaffold.of(widget.context).showSnackBar(
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
          Scaffold.of(widget.context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        } else {
          print(CustomTrace(StackTrace.current, message: response.body)
              .toString());
          Scaffold.of(widget.context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        }
      });
    } else {
      getItemDetails(widget.meal.id.toString()).then((response) {
        print("hereItemDetails${response.body}");
        if (response.statusCode == 200) {
          print("DONE: 265 ${widget.meal.id.toString()}");
          var itemDetails = ItemDetails.fromJson(json.decode(response.body));
          if (!CommonMethods.isItemEmpty(itemDetails)) {
            print("DONE: 268");

//            Navigator.of(widget.context).pushNamed('/ItemCustomisationPage',
//                arguments: mealCustomizationArguments);
            widget.pageBar.itemCustomization(mealCustomizationArguments);
          } else {

            print("DONE: 273");
            _con
                .addItemToCart(
                widget.context,
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
                  Scaffold.of(widget.context).showSnackBar(
                      SnackBar(content: Text(value.response.message)));
                  getCart();
                } else if (value.response.code == 202) {
                  Widget cancelButton = FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(widget.context);
                    },
                  );
                  Widget continueButton = FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(widget.context);
                      _con
                          .addItemToCart(
                          widget.context,
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
                        Scaffold.of(widget.context).showSnackBar(
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
          Scaffold.of(widget.context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        } else {
          print(CustomTrace(StackTrace.current, message: response.body)
              .toString());
          Scaffold.of(widget.context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        }
      });
    }
  }


  getQuantity() {
    if (viewCartResponse == null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 20,
          child: CircularLoadingWidget(
            height: 20,
          ),
        ),
      );
    } else {
      int cartId = 0;
      int _itemCount = 0;
      if (viewCartResponse.response.data != null &&
          viewCartResponse.response.data.restaurantList != null) {
        for (var restaurant in viewCartResponse.response.data.restaurantList) {
          if (restaurant.restaurantId == widget.restaurantId) {
            for (var foodDetail in restaurant.foodDetail) {
              if (foodDetail.menuId == widget.meal.id) {
                _itemCount = foodDetail.quantity;
                cartId = foodDetail.cartId;
              }
            }
          }
        }
      }
      return Row(
        children: <Widget>[
          _itemCount != 0
              ? new IconButton(
                  icon: new Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_itemCount == 1) {
                      _con
                          .removeFromCart(context, cartId.toString(), _con)
                          .then((value) {
                        if (value.response.code == 200)
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(value.response.message),
                          ));
                      });
                    }
                    if (cartId != 0 || _itemCount != 1) {
                      _con
                          .addMealToCart(
                              widget.context,
                              _con.scaffoldKey,
                              cartId,
                              widget.meal.id,
                              null,
                              null,
                              null,
                              widget.meal.restaurantId,
                              _itemCount - 1,
                              false)
                          .then((value) {
                        if (value != null) {
                          if (value.response.code == 200) {
                            Scaffold.of(widget.context).showSnackBar(SnackBar(
                                content: Text("Removed Successfully")));
                            getCart();
                          } else if (value.response.code == 202) {
                            Widget cancelButton = FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(widget.context);
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Yes"),
                              onPressed: () {
                                Navigator.pop(widget.context);
                                _con
                                    .addMealToCart(
                                        widget.context,
                                        _con.scaffoldKey,
                                        cartId,
                                        widget.meal.id,
                                        null,
                                        null,
                                        null,
                                        widget.meal.restaurantId,
                                        _itemCount - 1,
                                        true)
                                    .then((value) {
                                  Scaffold.of(widget.context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(value.response.message)));
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
                      Scaffold.of(widget.context).showSnackBar(SnackBar(
                          content: Text('This item is not present in cart')));
                      getCart();
                    }
                  },
                  iconSize: 20,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.deepPurpleAccent,
                )
              : new Container(),
          new Text(
            _itemCount.toString(),
            style: TextStyle(color: const Color(0xFF736F83)),
          ),
          new IconButton(
            icon: new Icon(Icons.add_circle_outline),
            onPressed: () {
              if (_itemCount == 0) {
                openMealCustomisationPage(cartId);
              } else {
                if (cartId != 0) {
                  _con
                      .addMealToCart(
                          widget.context,
                          _con.scaffoldKey,
                          cartId,
                          widget.meal.id,
                          null,
                          null,
                          null,
                          widget.meal.restaurantId,
                          _itemCount + 1,
                          false)
                      .then((value) {
                    if (value != null) {
                      if (value.response.code == 200) {
                        Scaffold.of(widget.context).showSnackBar(
                            SnackBar(content: Text(value.response.message)));
                        getCart();
                      } else if (value.response.code == 202) {
                        Widget cancelButton = FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(widget.context);
                          },
                        );
                        Widget continueButton = FlatButton(
                          child: Text("Yes"),
                          onPressed: () {
                            Navigator.pop(widget.context);
                            _con
                                .addMealToCart(
                                    widget.context,
                                    _con.scaffoldKey,
                                    cartId,
                                    widget.meal.id,
                                    //widget.meal.price,
                                    null,
                                    null,
                                    null,
                                    widget.meal.restaurantId,
                                    _itemCount + 1,
                                    true)
                                .then((value) {
                              Scaffold.of(widget.context).showSnackBar(SnackBar(
                                  content: Text(value.response.message)));
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
                          context: widget.context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      }
                    }
                  });
                }
              }
            },
            iconSize: 20,
            padding: EdgeInsets.symmetric(horizontal: 5),
            color: Colors.deepPurpleAccent,
          )
        ],
      );
    }
  }
}
