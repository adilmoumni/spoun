import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/generated/l10n.dart';
import 'package:food_delivery_app/src/elements/CircularLoadingWidget.dart';
import 'package:food_delivery_app/src/elements/NotificationListWidget.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/helpers/custom_trace.dart';
import 'package:food_delivery_app/src/helpers/helper.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import 'package:food_delivery_app/src/models/last_order_response.dart';
import 'package:food_delivery_app/src/models/order_details_response.dart';
//import 'package:food_delivery_app/src/models/pageBar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../session_manager.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/home_controller.dart';
import '../elements/BannersWidgetNew.dart';
import '../elements/DiningAreasNearbyWidget.dart';
import '../elements/PreferredMealsWidget.dart';
import '../helpers/Callback.dart';
import '../repository/order_repository.dart';

class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  PageBar pageBar;

  HomeWidget({Key key, this.parentScaffoldKey, this.pageBar}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> implements Callback {


  HomeController _con;
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  var currentLocation;
  bool triedLocation = false;
  Position position;
  Widget locationWidget;
  String error;
  LastOrderResponse lastOrderResponse;
  OrderDetailsResponse orderDetailsResponse;
  TextEditingController ratingController = TextEditingController();
  bool didCheckGps = false;

  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }



  void _onRated(dynamic rating) {
    this.ratingController.text = rating.toString();
    print("Rating: " + rating.toString());
  }

  void _modalBottomSheetMenu() {

    print(lastOrderResponse.response.data.first.diningName);

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return new Container(
            height: 350.0,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: 40, right: 30, bottom: 20),
                      child: new Text(
                        "Share your last dining experience at \n " +
                            lastOrderResponse.response.data.first.diningName,

                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: lastOrderResponse
                            .response.data.first.restaurantDetail.length,
                        itemBuilder: (context, index) {
                          return getRestaurantDetail(lastOrderResponse
                              .response.data.first.restaurantDetail[index]);
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 50,
                      height: 35,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 140, right: 140, top: 20),
                        child: FlatButton(
                          color: const Color(0xFF6244E8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: const Color(0xFF6244E8))),
                          child: new Text(S.of(context).submit,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Montserrat-Bold',
                              )),
                          onPressed: () {
                            _con.restaurantRating(
                                context,
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.restaurantId,
                                double.parse(ratingController.text),
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.orderId);

                            Future.delayed(const Duration(milliseconds: 3), () {
                              Navigator.of(context).pop(false);
                            });

                            SessionManager.setIsRated();

                            setState(() {});
                            isRatingDone();

                            print("Order Id :::: " +
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.orderId
                                    .toString());
                            print("Rating ::::" + ratingController.text);
                            print("Restaurant ID :::: " +
                                lastOrderResponse.response.data.first
                                    .restaurantDetail.first.restaurantId
                                    .toString());
                          },
                        ),
                      ),
                    ),
                  ],
                )),
          );
        });
  }

  getRestaurantDetail(RestaurantDetail detail) {
    double rating = 0.0;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 30, right: 60, top: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          child: CachedNetworkImage(
                            width: TextSize.ADD_PIC_WIDTH,
                            height: TextSize.ADD_PIC_WIDTH,
                            fit: BoxFit.cover,
                            imageUrl: detail.image == null
                                ? 'http://chamseddinprod.n1.iworklab.com/images/restaurant_image/rest1.jpeg'
                                : detail.image,
                            placeholder: (context, url) =>
                                CircularLoadingWidget(height: 50),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Column(
                        children: [
                          Text("How was " + detail.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: TextSize.LOGO_PADDING_SIZE,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: SmoothStarRating(
                              rating: lastOrderResponse.response.data.first
                                          .restaurantDetail.first.rate ==
                                      null
                                  ? 0.0
                                  : lastOrderResponse.response.data.first
                                      .restaurantDetail.first.rate
                                      .toDouble(),
                              isReadOnly: false,
                              size: 40,
                              filledIconData: Icons.star,
                              borderColor: Colors.deepPurpleAccent,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              color: Colors.deepPurpleAccent,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 1.0,
                              onRated: _onRated,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ]),
      ),
    ]);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (didCheckGps == true) {
        getlocation();
      }
      //PermissionHandler()
      //  .checkPermissionStatus(PermissionGroup.locationWhenInUse)
      //.then(_updateStatus);
    }
  }

  getlocation() async {
    bool serviceEnabled = await Geolocator().isLocationServiceEnabled();
    // await Future.delayed(const Duration(milliseconds: 400), () async {

    if (serviceEnabled == true) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.of(context).pop(true);
      });
      getDataBasedOnLocation();
      didCheckGps = false;
    } else {
      getDataWithoutLocation();
      setState(() {
        Navigator.of(context).pop(true);
      });
      didCheckGps = false;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () => Helper.of(context).onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: null,
          actions: [
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(""),
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
                                        color: Colors.deepPurpleAccent,
                                        size: 28),
                                    badgeColor: Colors.deepPurpleAccent,
                                  )
                                : Icon(Icons.notifications,
                                    color: Colors.deepPurpleAccent, size: 28),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _con.refreshHome,
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: currentLocation == null
                  ? locationWidget
                  : getDataBasedOnLocation()),
        ),
      ),
    );
  }

  int notificationsCount;

  Future<void> initState() {
    super.initState();

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then(((currentLoc) {
      setState(() {
        triedLocation = true;
        currentLocation = currentLoc;
        locationWidget = getDataBasedOnLocation();
      });
    })).catchError((onError) {
      print(onError);
      setState(() {
        getDataWithoutLocation();
      });
    });

    FBroadcast.instance().register(Constants.unreadNotificationsCount,
        (value, callback) {
      /// get data
      notificationsCount = value;
      setState(() {});
    });
    CommonMethods.getNotifications();

    locationWidget = getDataBasedOnLocation();

    getLastOrder();
    isRatingDone();
  }

  // ignore: missing_return
  Future<bool> isRatingDone() async {
    var isRated = await SessionManager.getIsRated();
    int popupTime = await SessionManager.getpopupTime();
    int now = DateTime.now().millisecondsSinceEpoch;
    print("DONE: isRated $isRated popupTime $popupTime now $now");
    if (isRated == false && now >= popupTime) {
      Future.delayed(const Duration(seconds: 10), () {
        _modalBottomSheetMenu();
      });
    }
  }

  getLastOrder() {
    lastOrder().then((response) {
      if (response.statusCode == 200 || response.statusCode == 202) {
        print(response.body);
        lastOrderResponse =
            LastOrderResponse.fromJson(jsonDecode(response.body));

        setState(() {});
      } else {
        lastOrderResponse = new LastOrderResponse();
        print(
            CustomTrace(StackTrace.current, message: response.body).toString());
      }
    });
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      getDataBasedOnLocation();
      return true;
    }
    getDataWithoutLocation();
    return false;
  }

/*Checking if your App has been Given Permission*/
  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

/*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android ||
          Theme.of(context).platform == TargetPlatform.iOS) {
        showDialog(
            context: context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  " Can't get current location",
                  style: TextStyle(color: Colors.deepPurpleAccent),
                ),
                content: const Text(
                    'Do you want to allow this app to use your location?'),
                actions: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      new GestureDetector(
                        onTap: () {
                          didCheckGps = true;
                          final AndroidIntent intent = AndroidIntent(
                              action:
                                  'android.settings.LOCATION_SOURCE_SETTINGS');
                          intent.launch();
                          // Future.delayed(const Duration(milliseconds: 200), () {
                          //   Navigator.of(context)..pop(true)..pop(true)..pop(true);
                          // });
                          // // setState(() { });
                          // //Navigator.of(context).pop();
                          // _gpsService();
                          // getDataBasedOnLocation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Allow",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                        width: 10,
                      ),
                      new GestureDetector(
                        onTap: () {
                          getDataWithoutLocation();
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Navigator.of(context).pop(false);
                          });
                          setState(() {
                            Navigator.of(context).pop(false);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Deny",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
              Navigator.of(context).pop();
            });
      }
    }
  }

  Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  @override
  callBack(value) {}

  Widget getDataBasedOnLocation() {
    if (currentLocation == null) {
      _checkGps();
    } else {
      return locationWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.only(top: 00, left: 12, right: 12, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(4)),
          ),
          BannersWidgetNew(
            currentLocation,
            pageBar: widget.pageBar,
          ),
          DiningAreasNearbyWidget(currentLocation, pageBar: widget.pageBar),
          PreferredMealsWidget(
            S.of(context).preferredMeals,
            Constants.PREFERRED_MEALS_TYPE_HOME,
            null,
            null,
            pageBar: widget.pageBar,
          ),
        ],
      );
    }
  }

  Widget getDataWithoutLocation() {
    locationWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 20, left: 12, right: 12, bottom: 12),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(4)),
        ),
        BannersWidgetNew(
          null,
          pageBar: widget.pageBar,
        ),
        DiningAreasNearbyWidget(
          null,
          pageBar: widget.pageBar,
        ),
        PreferredMealsWidget(
          S.of(context).preferredMeals,
          Constants.PREFERRED_MEALS_TYPE_HOME,
          null,
          null,
        ),
      ],
    );
  }
}
