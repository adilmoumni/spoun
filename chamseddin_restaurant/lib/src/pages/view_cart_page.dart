import 'dart:convert';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/cart_discount_arguments.dart';
import 'package:food_delivery_app/src/models/cart_discount_response.dart' as Discount;
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../controllers/restaurant_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/EmptyCartWidget.dart';
import '../elements/PreferredMealsCartWidget.dart';
import '../helpers/refresh_cart_listener.dart';
import '../models/Meals.dart';
import '../models/edit_cart_arguments.dart';
import '../models/payment_arguments.dart';
import '../models/specific_instructions_request.dart';
import '../models/view_cart_response.dart';
import 'pages.dart';

class ViewCartWidget extends StatefulWidget {
  PageBar pageBar;

  ViewCartWidget({Key key, this.pageBar}) : super(key: key);
  @override
  _ViewCartWidgetState createState() => _ViewCartWidgetState();
}

class _ViewCartWidgetState extends StateMVC<ViewCartWidget>
    implements RefreshCartListener {
  List<Meal> preferredMealsList;
  String diningAreaId;
  RestaurantController _con;
  ViewCartResponse viewCartResponse;
  Discount.GetCartDiscountResponse cart;
  RestaurantList restaurantList;
  TextEditingController promoCodeControllers = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  _ViewCartWidgetState() : super(RestaurantController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    getCart();
  }
  double doubleConvert(dynamic value){
    if(value!=null && value.toString()!=""){
     return double.parse(value.toString());
    }else{
      return 0.0;
    }
  }


  void getCart() {
    _con.getCart().then((response) {
      this.viewCartResponse = response ;
      setState(() {});
    });
  }

  List<GetDiscountRequest> argu = List();
  // List<dynamic> promoCode=[];
  // List<dynamic> promoCodeId =[];

  getCartDiscount(
      BuildContext context, int restaurantId, String promoCode) {
    FocusScope.of(context).unfocus();
    GetDiscountRequest getDiscountRequest = GetDiscountRequest();
    getDiscountRequest.restaurantId = restaurantId;
    print("Restaurant ID :::::" + restaurantId.toString());
    getDiscountRequest.promoCode = promoCode;
    print("Promo Code :::::" + promoCode);
    argu.add(getDiscountRequest);
   // Flushbar(
    //  message: "Applied successfully",
     // duration: Duration(seconds: 3),
    //).show(context);
  }

  onSubmit() {
    _con.getDiscountCart(argu).then((response) {
      if (response.statusCode == 200 || response.statusCode == 202) {
        print("hellohere$response.body");
        viewCartResponse = ViewCartResponse.fromJson(jsonDecode(response.body));
        /* argu.clear();*/
        setState(() {});
      } else {
        viewCartResponse = new ViewCartResponse();
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
      }
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
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _con.scaffoldKey,
          bottomNavigationBar: viewCartResponse == null ||
              viewCartResponse.response.data == null ||
              viewCartResponse.response.data.restaurantList == null
              ? null
              : RaisedButton(
            color: const Color(0xFF6244E8),
            child: Text(
              S.of(context).select_payment_method_to_place_order,
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              var specificInstructionsRequest =
              new List<SpecificInstructionsRequest>();
              if (viewCartResponse.response.data.restaurantList != null &&
                  viewCartResponse
                      .response.data.restaurantList.isNotEmpty) {
                for (var list
                in viewCartResponse.response.data.restaurantList) {
                  specificInstructionsRequest.add(
                      SpecificInstructionsRequest(
                          list.restaurantId.toString(),
                          list.specificInstructions));
                }
              }
              // PromoDiscountRequest promoDiscountRequest =
              // PromoDiscountRequest();
              // if (cart == null) {
              //   promoDiscountRequest.restaurantId =
              //       viewCartResponse.response.data.restaurantList.first.restaurantId;
              //   if (viewCartResponse.response.data.restaurantList.first.discount ==
              //       null) {
              //     promoDiscountRequest.discount = 0.00;
              //   } else {
              //     promoDiscountRequest.discount = viewCartResponse
              //         .response.data.restaurantList.first.discount
              //         .toDouble();
              //   }
              //   List<PromoDiscountRequest> promoDiscounts=[];
              //   promoDiscounts.add(promoDiscountRequest);
              //   List<dynamic> promoIds = null;
              //   if (viewCartResponse.response.data.restaurantList.first.promoId!=null)
              //   {
              //     promoIds=[];
              //     promoIds
              //         .add(viewCartResponse.response.data.restaurantList.first.promoId);
              //   }
              //
              //   var paymentArguments = PaymentArguments(
              //       viewCartResponse.response.data.grandTotal,
              //       viewCartResponse.response.data.vat,
              //       viewCartResponse.response.data.service_fee.toString(),
              //       true,
              //       specificInstructionsRequest,
              //       promoDiscounts,
              //       promoIds);
              //   widget.pageBar.paymentCart(paymentArguments);
              // } else {
                List<PromoDiscountRequest> argu = [];
                for(int i=0; i< viewCartResponse.response.data.restaurantList.length;i++){
                  argu.add(new PromoDiscountRequest(restaurantId:  viewCartResponse.response.data.restaurantList[i].restaurantId,
                  discount:viewCartResponse.response.data.restaurantList.first.discount == null ? 0.00: viewCartResponse.response.data.restaurantList[i].discount.toDouble()));
                }


                List<dynamic> argu1 = List();
                for(int i =0; i<viewCartResponse.response.data.restaurantList.length; i++){
                  argu1.add(viewCartResponse.response.data.restaurantList[i].promoId);
                }


                var paymentArguments = PaymentArguments(
                    viewCartResponse.response.data.grandTotal.toDouble(),
                    viewCartResponse.response.data.vat.toDouble(),
                    viewCartResponse.response.data.service_fee.toString(),
                    true,
                    specificInstructionsRequest,
                    argu,
                    argu1);

                // List<dynamic> argu1 = List();
                // for (var list1 in cart.response.data.restaurantList) {
                //   argu1.add(list1.promoId);
                // }

                widget.pageBar.paymentCart(paymentArguments);
              }
            // },
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PagesWidget(),
                ),
              ),
              icon:  Icon(Platform.isAndroid
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios_sharp,

              color: Colors.black26,
            )),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                      child: Text(S.of(context).check_out,
                          style: TextStyle(
                              color: const Color(0xFF6244E8),
                              fontSize: TextSize.TEXT2,
                              fontFamily: 'Montserrat-Bold',
                              fontWeight: FontWeight.bold)),
                      padding: EdgeInsets.only(top: TextSize.TEXT1)),
                ),
              ),
              PreferredMealsCartWidget(
                S.of(context).add_preferred_meals,
                null,
                null,
                null,
                this,
                pageBar: widget.pageBar,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 10),
                child: ListTile(
                  subtitle: Text(S.of(context).my_cart,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.bold)),
                ),
              ),
              viewCartResponse == null || viewCartResponse.response.data == null ||
                  viewCartResponse.response.data.restaurantList ==
                      null ||
                  viewCartResponse.response.data.restaurantList.isEmpty
                  ? EmptyCartWidget()
                  : viewCartResponse.response.data == null ||
                  viewCartResponse.response.data.restaurantList ==
                      null ||
                  viewCartResponse.response.data.restaurantList.isEmpty
                  ? EmptyCartWidget()
                  : Column(
                children: [
                  ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: viewCartResponse
                        .response.data.restaurantList.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      return getRestaurantListItems(viewCartResponse
                          .response.data.restaurantList[index]);
                    },
                  ),
                  /*Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),*/
                  /*Padding(
                              padding: EdgeInsets.only(left: 10, right: 50, top: 10),
                              child: ButtonTheme(
                                minWidth: 20,
                                height: 25,
                                child: FlatButton(
                                  color: const Color(0xFF6244E8),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(color: const Color(0xFF6244E8))),
                                  child: new Text("Apply Promo Code",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: TextSize.SOCIAL_PADDING_SIZE,
                                        fontFamily: 'Montserrat',
                                      )),
                                  onPressed: () {
                                    onSubmit();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),*/
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).service_fee,
                          style: TextStyle(fontSize: 12),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 70),
                            child: cart == null
                                ? Text(
                                '${viewCartResponse.response.data.service_fee} ' + viewCartResponse.response.data.currency_symbol)
                                : Text(
                                '${cart.response.data.serviceFee}' + viewCartResponse.response.data.currency_symbol)),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).vat),
                          Padding(
                              padding: EdgeInsets.only(left: 110),
                              child: cart == null
                                  ? Text(
                                  '${viewCartResponse.response.data.vat}' + viewCartResponse.response.data.currency_symbol)
                                  : Text(
                                  '${cart.response.data.vat}' + viewCartResponse.response.data.currency_symbol)),
                        ],
                      )),
                  Container(
                    margin:
                    EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).grand_total),
                          cart == null
                              ? Text(
//                                      cart.response.data.grandTotal
                            viewCartResponse
                                .response.data.grandTotal
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey),
                          )
                              : Text(
                            cart.response.data.grandTotal
                                .toStringAsFixed(2),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  @override
  onRefreshCart() {
    getCart();
  }

  Widget getRestaurantListItems(RestaurantList restaurantList) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(restaurantList.restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Montserrat-Bold',
                      fontWeight: FontWeight.bold)),
              ButtonTheme(
                minWidth: 50,
                height: 25,
                child: OutlineButton(
                    child: new Text('EDIT',
                        style: TextStyle(
                            color: const Color(0xFF6244E8),
                            fontSize: 12,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      var editCartArguments = EditCartArguments(
                          restaurantList, restaurantList.restaurantId);
                      widget.pageBar.editCart(editCartArguments);
//                      Navigator.of(context)
//                          .pushNamed('/EditCart', arguments: editCartArguments);
                    },
                    borderSide: BorderSide(
                         color: const Color(0xFF6244E8),
                        width: 1,
                        style: BorderStyle.solid),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0))),
              ),
            ],
          ),
        ),
        Container(),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          primary: false,
          itemCount: restaurantList.foodDetail.length,
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            return Container(
              margin:
              const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 10),
              padding: const EdgeInsets.all(7.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            restaurantList.foodDetail[index].quantity > 1
                                ? restaurantList.foodDetail[index].name +
                                " x " +
                                restaurantList.foodDetail[index].quantity
                                    .toString()
                                : restaurantList.foodDetail[index].name,
                            style: new TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6244E8),
                            ),
                          ),
                          width: TextSize.BUTTON_WIDTH,
                        ),
                        Divider(
                          color: Colors.black26,
                        ),
                        restaurantList.foodDetail[index].addon != null &&
                            restaurantList.foodDetail[index].addon.length >
                                0
                            ? new Text('Customization and add-on x ' +
                            restaurantList.foodDetail[index].addon.length
                                .toString())
                            : new Text('Customization'),
                        restaurantList.foodDetail[index].lists != null &&
                            restaurantList.foodDetail[index].lists.length >
                                0
                            ? new Text('Customization x ' +
                            restaurantList.foodDetail[index].lists.length
                                .toString())
                            : new Text('Customization'),
                      ],
                    ),
                    Spacer(),
                    Text(
                      (doubleConvert((restaurantList.foodDetail[index].price) * restaurantList.foodDetail[index].quantity).toStringAsFixed(2)),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.grey),
                    ),
                    // IconButton(
                    //     icon: Image.asset(
                    //       "assets/img/delate.png",
                    //     ),
                    //     iconSize: 12,
                    //     color: null,
                    //     onPressed: () {
                    //       _con
                    //           .removeFromCart(
                    //           context,
                    //           restaurantList.foodDetail[index].cartId
                    //               .toString(),
                    //           _con)
                    //           .then((value) {
                    //         if (value.response.code == 200) {
                    //           getCart();
                    //         }
                    //         Scaffold.of(context).showSnackBar(SnackBar(
                    //           content: Text(value.response.message),
                    //         ));
                    //       });
                    //     })
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
                Text(S.of(context).sous_total),
                Text( restaurantList.beforeDiscount == null ? restaurantList.restTotal.toStringAsFixed(2) : restaurantList.beforeDiscount.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        restaurantList.promoId == null
            ? Text("")
            : Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).discount),
                Text(
                  "-" + restaurantList.discount.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        restaurantList.promoId == null
            ? Text("")
            : Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(S.of(context).restaurant_total),
                Text(
                  restaurantList.restTotal.toStringAsFixed(2),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10, right:215),
          child: Text(
            S.of(context).promotion_code,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
        ),
        promoCode(restaurantList),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[200]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).specific_instructions,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                      onChanged: (text) {
                        restaurantList.specificInstructions = text;
                      },
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black26),
                        hintText: S.of(context).specific_instructions + " ...",
                      )),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  promoCode(RestaurantList restaurantList) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: 1,
        itemBuilder: (context, index) {
          final int _fields = restaurantList.foodDetail.length;
          List<TextEditingController> controllers;
          controllers = List.generate(_fields, (i) => TextEditingController());
          return Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 0),
                      child: TextFormField(
                        controller: controllers[index],
                        onChanged: (value) {
                          value = controllers[index].text;
                        },
                        onFieldSubmitted: (value) {
                          value = getCartDiscount(context,restaurantList.restaurantId,controllers[index].text);
                          controllers[index].clear();
                        },
                        onSaved: (value) {
                          value = getCartDiscount(context,restaurantList.restaurantId,controllers[index].text);
                          controllers[index].clear();
                        },
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.all(8.0),
                            hintText: restaurantList.promoCode == null
                                ? "Please enter your promotion code if you have one"
                                : restaurantList.promoCode,
                            hintStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                                height: 0.0)),
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 50, top: 10),
                  child: ButtonTheme(
                    minWidth: 20,
                    height: 25,
                    child: FlatButton(
                      color: const Color(0xFF6244E8),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: const Color(0xFF6244E8))),
                      child: new Text(S.of(context).apply,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: TextSize.PADDING_SIZE,
                            fontFamily: 'Montserrat',
                          )),
                      onPressed: () {
                        print(
                            'current field index is $index and new value is');
                        getCartDiscount(
                            context,
                            restaurantList.restaurantId,
                            controllers[index].text);
                        onSubmit();
                        setState(() {
                          /*controllers[index].clear();*/
                        });
                      },
                    ),
                  ),
                ),
              ]),
              Padding(
                  padding: EdgeInsets.only(left: 10, top: 5, right: 210),
                  child: Text(
                    restaurantList.promoResponse == null
                        ? ""
                        : restaurantList.promoResponse,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.deepPurpleAccent,
                    ),
                  )),
            ],
          );

        });
  }
}
