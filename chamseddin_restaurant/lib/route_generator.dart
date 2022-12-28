import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/pages/dispute.dart';
import 'package:food_delivery_app/src/pages/pdf_invoice.dart';
import 'package:food_delivery_app/src/pages/qr_code.dart';
import 'package:food_delivery_app/src/pages/web_view_page.dart';
import 'src/models/meal_customisation_arguments.dart';
import 'src/models/route_argument.dart';
import 'src/pages/cart.dart';
import 'src/pages/checkout.dart';
import 'src/pages/dining_area_page.dart';
import 'src/pages/edit_cart_page.dart';
import 'src/pages/filters.dart';
import 'src/pages/forget_password.dart';
import 'src/pages/home.dart';
import 'src/pages/item_customisation_page.dart';
import 'src/pages/login.dart';
import 'src/pages/map.dart';
import 'src/pages/meal_customisation_page.dart';
import 'src/pages/order_details.dart';
import 'src/pages/order_successful.dart';
import 'src/pages/pages.dart';
import 'src/pages/payment_screen.dart';
import 'src/pages/profile.dart';
import 'src/pages/restaurant_page.dart';
import 'src/pages/signup.dart';
import 'src/pages/splash_screen.dart';
import 'src/pages/view_cart_page.dart';
import 'src/paypal/paypal_payment.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpWidget(null));
      case '/MobileVerification':
        return MaterialPageRoute(builder: (_) => SignUpWidget(null));
      case '/MobileVerification2':
        return MaterialPageRoute(builder: (_) => SignUpWidget(null));
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Home':
        return MaterialPageRoute(builder: (_) => HomeWidget());
      case '/DiningArea':
        return MaterialPageRoute(builder: (_) => DiningAreaWidget(args));
      case '/ViewCart':
        return MaterialPageRoute(builder: (_) => ViewCartWidget());
      case '/OrderDetails':
        return MaterialPageRoute(builder: (_) => OrderDetailsWidget(args));
      case '/EditCart':
        return MaterialPageRoute(builder: (_) => EditCartWidget(args));
      case '/RestaurantMap':
        return MaterialPageRoute(builder: (_) => MapWidget(args));
      case '/RestaurantPage':
        return MaterialPageRoute(builder: (_) => RestaurantWidget(args));
        case '/WebViewPage':
        return MaterialPageRoute(builder: (_) => WebViewWidget(args));
      case '/ViewPDF':
        return MaterialPageRoute(builder: (_) => ViewPdfWidget(args));
      case '/MealCustomisationPage':
        return MaterialPageRoute(
            builder: (_) =>
                MealCustomisationWidget(args as MealCustomizationArguments));
      case '/ItemCustomisationPage':
        return MaterialPageRoute(
            builder: (_) =>
                ItemCustomisationWidget(args as MealCustomizationArguments));
      case '/Profile':
        return MaterialPageRoute(builder: (_) => ProfileWidget());
      case '/ForgetPassword':
        return MaterialPageRoute(builder: (_) => ForgetPasswordWidget());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesWidget(currentTab: args));
      case '/Cart':
        return MaterialPageRoute(
            builder: (_) => CartWidget(routeArgument: args as RouteArgument));
      case '/Filters':
        return MaterialPageRoute(builder: (_) => FiltersWidget());
      case '/PaymentScreen':
        return MaterialPageRoute(builder: (_) => PaymentScreenWidget(args));
//      case '/Checkout':
//        return MaterialPageRoute(builder: (_) => CheckoutWidget());
      case '/QRCode' :
        return MaterialPageRoute(builder: (_) => QRcodeWidget(args));
      case '/AskForDispute' :
        return MaterialPageRoute(builder: (_) => DisputeWidget(args));
      case '/PayPal':
        return MaterialPageRoute(
            builder: (_) => PaypalPayment(
                  paypalArguments: args,
                ));
      case '/OrderSuccesful':
        return MaterialPageRoute(builder: (_) => OrderSuccessfulWidget(args));
      case '/Notification' :
        return MaterialPageRoute(builder: (_) => NotificationListingWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
