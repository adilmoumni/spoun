import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/session_manager.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/place_order_response.dart';
import 'package:food_delivery_app/src/paypal/paypal_arguments.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/payment_cards_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../elements/stripe_payment_widget.dart';
import '../models/customers.dart';
import '../models/payment_arguments.dart';
import '../models/payment_methods.dart';
import '../models/place_order_request.dart';
import '../repository/user_repository.dart' as userRepo;

class PaymentScreenWidget extends StatefulWidget {
  final PaymentArguments paymentArguments;
  PageBar pageBar;


  PaymentScreenWidget(this.paymentArguments, {Key key, this.pageBar}) : super(key: key);

  @override
  _PaymentScreenWidgetState createState() => _PaymentScreenWidgetState();
}

class _PaymentScreenWidgetState extends StateMVC<PaymentScreenWidget>
    implements PaymentCompletedCallback, GetCustomerCallback {
  PaymentCardController _payment_con;
  Data selectedPaymentMethod;
  bool isPaypalSelected = false;
  Customer customer;
  PaymentMethods savedCards;
  PlaceOrderResponse placeOrderResponse;
  OverlayEntry loader;
  bool isEnable = true;

  _PaymentScreenWidgetState() : super(PaymentCardController()) {
    _payment_con = controller;
    _payment_con.getCustomer(userRepo.currentUser.value.id, this);
  }

  @override
  void dispose() {
    super.dispose();
    print('Payment screen disposed');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamed('/Pages', arguments: 1);
      },
        child: Scaffold(
      key: _payment_con.scaffoldKey,
          bottomNavigationBar: getPaymentButton(),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 1),
              icon:  Icon(Platform.isAndroid
                  ? Icons.arrow_back
                  : Icons.arrow_back_ios_sharp),

              color: Colors.black26,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
          body: showCustomerData(),
    )
    );
  }

  Widget getPaymentButton() {
    if (widget.paymentArguments != null &&
        widget.paymentArguments.makePayment) {
      if (selectedPaymentMethod == null && !isPaypalSelected) {
        return RaisedButton(
          color: const Color(0xFF6244E8),
          child: Text(
            S.of(context).select_payment_method_to_place_order,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
        );
      }
      if (isPaypalSelected) {
        return RaisedButton(
          color: const Color(0xFF6244E8),
          child: Text(
            "Continue with Paypal",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            PaypalArguments paypalArguments = new PaypalArguments(
                this, widget.paymentArguments.payment_amount);
            Navigator.of(context)
                .pushNamed('/PayPal', arguments: paypalArguments);
          },
        );
      }
      return RaisedButton(
          color: const Color(0xFF6244E8),
          child: Text(
            "Pay with card ending in - " + selectedPaymentMethod.card.last4,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (customer != null && isEnable == true) {
              _payment_con.payByCard(selectedPaymentMethod.id,
                  widget.paymentArguments.payment_amount, customer.id, this);
               isEnable = false;
            } else {
              return null;
            }
          });
    } else {
      return Spacer();
    }
  }

  void showSnackbar(dynamic error) {
    _payment_con.scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  @override
  error(message) {
    showSnackbar("Failed to complete payment : " + message);
  }



  @override
  successCallBack() {
    var placeOrderRequest = PlaceOrderRequest(
        widget.paymentArguments.payment_amount.toString(),
        widget.paymentArguments.vat.toString(),
        widget.paymentArguments.serviceFee.toString(),
        'Test',
        'card',
        widget.paymentArguments.specificInstructionsRequest,
        widget.paymentArguments.promoDiscount,
        widget.paymentArguments.promoId);
    _payment_con.placeOrder(placeOrderRequest).then((value) {
      SessionManager.setRating();
        widget.pageBar.orderSuccessful(value);
      });
  }

  @override
  onCustomerFetched(Customer customer) {
    this.customer = customer;
    loadSavedCards();
  }

  Widget showSavedCards() {
    if (savedCards == null) {
      return Column(
        children: [
          Text('Loading your saved cards'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularLoadingWidget(height: 50),
          ),
        ],
      );
    }
    if (savedCards.data == null || savedCards.data.length == 0) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        child: Text('No saved cards yet. Add new card to continue'),
      );
    } else {
      return ListView.builder(
        itemCount: savedCards.data.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: getCardRow,
      );
    }
  }

  Widget getCardRow(BuildContext context, int index) {
    Data paymentMethod = savedCards.data[index];
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
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
          Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: getSelectedCheckbox(paymentMethod),
                onPressed: () {
                  if (selectedPaymentMethod != null &&
                      paymentMethod.id == selectedPaymentMethod.id) {
                    unSelectCard(paymentMethod);
                  } else {
                    selectCard(paymentMethod);
                  }
                },
              )),
          Align(
            alignment: Alignment.center,
            child: Text(paymentMethod.card.brand +
                " card ending with " +
                paymentMethod.card.last4),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDeleteCardAlertDialog(context, paymentMethod);
                },
              )),
        ],
      ),
    );
  }

  Widget showCustomerData() {
    if (customer == null) {
      return CircularLoadingWidget(height: 50);
    } else {
      return ListView(
        padding: EdgeInsets.symmetric(vertical: 0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Text("Add new card",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
          ),
          StripePaymentWidget(onChanged: (paymentMethod) {
            if (customer != null) {
              _payment_con
                  .attachPaymentMethodToCustomer(
                      paymentMethod.id, customer.id, _payment_con.scaffoldKey)
                  .then((paymentMethods) {
                loadSavedCards();
              });
            }
          }),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
            child: Text("Saved cards",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Montserrat-Bold',
                    fontWeight: FontWeight.bold)),
          ),
          showSavedCards(),
          Container(
              margin: EdgeInsets.all(20),
              child: Center(
                  child: Text(
                'OR',
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ))),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: getSelectedPaypal(),
                      onPressed: () {
                        if (isPaypalSelected) {
                          unSelectPaypal();
                        } else {
                          selectPaypal();
                        }
                      },
                    )),
                Image.asset(
                  'assets/img/paypal2.png',
                  height: 28,
                ),
                Spacer()
              ],
            ),
          )
        ],
      );
    }
  }

  void loadSavedCards() {
    savedCards = null;
    setState(() {});
    _payment_con.getPaymentMethods(customer).then((paymentMethods) {
      savedCards = paymentMethods;
      setState(() {});
    });
  }

  selectPaypal() {
    selectedPaymentMethod = null;
    isPaypalSelected = true;
    setState(() {});
  }

  unSelectPaypal() {
    isPaypalSelected = false;
    setState(() {});
  }

  selectCard(Data paymentMethod) {
    isPaypalSelected = false;
    selectedPaymentMethod = paymentMethod;
    setState(() {});
  }

  unSelectCard(Data paymentMethod) {
    selectedPaymentMethod = null;
    setState(() {});
  }

  Widget getSelectedCheckbox(Data paymentMethod) {
    if (selectedPaymentMethod != null &&
        paymentMethod.id == selectedPaymentMethod.id) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.check_circle_outline);
    }
  }

  Widget getSelectedPaypal() {
    if (isPaypalSelected) {
      return Icon(Icons.check_circle);
    } else {
      return Icon(Icons.check_circle_outline);
    }
  }

  showDeleteCardAlertDialog(BuildContext context, Data paymentMethod) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: () {
        _payment_con
            .detachPaymentMethodFromCustomer(paymentMethod.id)
            .then((value) {
          loadSavedCards();
        });
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Card?",
        style: TextStyle(color: Colors.deepPurple),
      ),
      content:
          Text("Your saved card will be deleted. Do you want to continue?"),
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
