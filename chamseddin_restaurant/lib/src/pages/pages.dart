import 'package:badges/badges.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/DiningAreasNearbyWidget.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/elements/OrderListingWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/order_detail_arguments.dart';
import 'package:food_delivery_app/src/pages/changeLanguage.dart';
import 'package:food_delivery_app/src/pages/customerService.dart';
import 'package:food_delivery_app/src/pages/dispute.dart';
import 'package:food_delivery_app/src/pages/edit_cart_page.dart';
import 'package:food_delivery_app/src/pages/item_customisation_page.dart';
import 'package:food_delivery_app/src/pages/meal_customisation_page.dart';
import 'package:food_delivery_app/src/pages/myAccount.dart';
import 'package:food_delivery_app/src/models/user.dart';
import 'package:food_delivery_app/src/pages/order_details.dart';
import 'package:food_delivery_app/src/pages/order_successful.dart';
import 'package:food_delivery_app/src/pages/payment_method.dart';
import 'package:food_delivery_app/src/pages/payment_screen.dart';
import 'package:food_delivery_app/src/pages/qr_code.dart';
import 'package:food_delivery_app/src/pages/reset_user_password.dart';
import 'package:food_delivery_app/src/pages/restaurant_page.dart';
import 'package:food_delivery_app/src/pages/terms_conditions.dart';
import '../constants.dart';
import '../models/route_argument.dart';
import '../pages/favorites.dart';
import '../pages/home.dart';
import 'dining_area_page.dart';
import 'help.dart';
import 'profile.dart';
import 'view_cart_page.dart';

class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.method);
      }
    } else {
      currentTab = 0;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> implements PageBar {
  int cartCount;
  PageBar pageBar;
  User user;
  OrderDetailsArguments orderDetailsArguments;

  initState() {
    super.initState();

    /// register
    FBroadcast.instance().register(Constants.cartCount, (value, callback) {
      /// get data
      cartCount = value;
      setState(() {});
    });
    CommonMethods.getCartCount();
    _selectTab(widget.currentTab);
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = HomeWidget(
            parentScaffoldKey: widget.scaffoldKey,
            pageBar: this,
          );
          break;
        case 1:
          widget.currentPage = ViewCartWidget(
            pageBar: this,
          );
          break;
        case 2:
          widget.currentPage = FavoritesWidget(
            parentScaffoldKey: widget.scaffoldKey,
            pageBar: this,
          );
          break;
        case 3:
          widget.currentPage = ProfileWidget(
            parentScaffoldKey: widget.scaffoldKey,
            pageBar: this,
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
//      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.grey,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme:
              IconThemeData(size: 28, color: Colors.deepPurpleAccent),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            this._selectTab(i);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: cartCount != null && cartCount > 0
                  ? Badge(
                      badgeContent: Text(
                        cartCount.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(Icons.shopping_cart),
                      badgeColor: Colors.deepPurpleAccent,
                    )
                  : Icon(Icons.shopping_cart),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.favorite,
//                color: Colors.grey,
              ),
              title: new Container(height: 0.0),
            ),
            BottomNavigationBarItem(
              icon: new Icon(
                Icons.person,
//                color: Colors.grey,
              ),
              title: new Container(height: 0.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  myAccount(String myAccount) {
    // TODO: implement myAccount
    widget.currentPage = MyAccountWidget(user);
    setState(() {});
  }

  @override
  customerService(String customerService) {
    // TODO: implement customerService
    widget.currentPage = CustomerServiceWidget(
      pageBar: this,
    );
    setState(() {});
  }

  @override
  help(String help) {
    // TODO: implement help
    widget.currentPage = HelpWidget();
//        WebViewWidget('https://www.chamseddinweb.n1.iworklab.com');
    setState(() {});
  }

  @override
  orderListing(String orderListing) {
    // TODO: implement orderListing
    widget.currentPage = OrderListingWidget(
      pageBar: this,
    );
    setState(() {});
  }

  @override
  payment(String payment) {
    // TODO: implement paymentMethod
    widget.currentPage = PaymentMethodWidget(null);
    setState(() {});
  }

  @override
  changePassword(String resetPassword) {
    // TODO: implement resetPassword
    widget.currentPage = ResetUserPasswordWidget();
    setState(() {});
  }

  @override
  termsAndConditions(String termsAndConditions) {
    // TODO: implement termsAndConditions
    widget.currentPage = TermsAndConditonsWidget();
//        WebViewWidget('https://www.chamseddinweb.n1.iworklab.com');
    setState(() {});
  }

  @override
  orderDetails(var orderDetails) {
    // TODO: implement orderDetails
    widget.currentPage = OrderDetailsWidget(
      orderDetails,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  showQrCode(qrCode) {
    // TODO: implement showQrCode
    widget.currentPage = QRcodeWidget(
      qrCode,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  showDiningArea(diningArea) {
    // TODO: implement showDiningArea
    widget.currentPage = DiningAreaWidget(
      diningArea,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  diningAreas(var diningArea, PageBar pageBar) {
    // TODO: implement diningAreas
    widget.currentPage = DiningAreasNearbyWidget(diningArea, pageBar: this);
    setState(() {});
  }

  @override
  showRestaurant(var restaurant) {
    // TODO: implement showRestaurant
    widget.currentPage = RestaurantWidget(
      restaurant,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  notifications(notifications) {
    // TODO: implement notifications
    widget.currentPage = NotificationListingWidget(
      pageBar: this,
    );
    setState(() {});
  }

  @override
  dispute(dispute) {
    // TODO: implement dispute
    widget.currentPage = DisputeWidget(
      dispute,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  editCart(editCart) {
    // TODO: implement editCart
    widget.currentPage = EditCartWidget(
      editCart,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  mealCustomization(meal) {
    // TODO: implement mealCustomization
    widget.currentPage = MealCustomisationWidget(
      meal,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  itemCustomization(item) {
    print("itemmera${item}");

    // TODO: implement itemCustomization
    widget.currentPage = ItemCustomisationWidget(
      item,
      pageBar: this,

    );
    setState(() {});
  }

  @override
  orderSuccessful(order) {
    // TODO: implement orderSuccessful
    widget.currentPage = OrderSuccessfulWidget(
      order,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  paymentCart(payment) {
    // TODO: implement paymentCart
    widget.currentPage = PaymentScreenWidget(
      payment,
      pageBar: this,
    );
    setState(() {});
  }

  @override
  changeLanguage(changeLanguage) {
    // TODO: implement changeLanguage
    widget.currentPage = ChangeLanguage(pageBar: this);
    setState(() {});
  }
}
