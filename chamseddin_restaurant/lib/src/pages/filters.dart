import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/helpers/common_methods.dart';
import 'package:food_delivery_app/src/helpers/cuisines_filters_listener.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../TextSize.dart';
import '../constants.dart';
import '../controllers/filters_controller.dart';
import '../elements/CircularLoadingWidget.dart';
import '../models/filters_list_response.dart';

class FiltersWidget extends StatefulWidget {
  final CuisinesFiltersListener cuisinesFiltersListener;

  FiltersWidget({Key key, this.cuisinesFiltersListener}) : super(key: key);

  @override
  _FiltersWidgetState createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends StateMVC<FiltersWidget> {
  FiltersController _con;
  FiltersListResponse filtersListResponse;
  List<int> selectedCuisinesIndexes = new List();
  int cartCount;

  _FiltersWidgetState() : super(FiltersController()) {
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
    CommonMethods.getCartCount();
    _con.getFilters().then((value) {
      filtersListResponse = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    FBroadcast.instance().unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/Pages');
            },
            child: Container(

              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: TextSize.ADDRESS_ALERT_TOP,
              width: MediaQuery.of(context).size.width/4.5,
//              color: Colors.black26,
              child: Column(
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 1);
            },
            child: Container(

              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: TextSize.ADDRESS_ALERT_TOP,
              width: MediaQuery.of(context).size.width/4.5,
//              color: Colors.black26,
              child: Column(
                children: [
                  cartCount != null && cartCount > 0
                      ? Badge(
                    badgeContent: Text(
                      cartCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(Icons.shopping_cart,
                        color: Colors.grey, size: 24),
                    badgeColor: Colors.deepPurpleAccent,
                  )
                      : Icon(Icons.shopping_cart,
                      color: Colors.grey, size: 24),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            child: Container(

              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: TextSize.ADDRESS_ALERT_TOP,
              width: MediaQuery.of(context).size.width/4.5,
//              color: Colors.black26,
              child: Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 3);
            },
            child: Container(

              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: TextSize.ADDRESS_ALERT_TOP,
              width: MediaQuery.of(context).size.width/4.5,
//              color: Colors.black26,
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      body: filtersListResponse == null
          ? CircularLoadingWidget(height: 400)
          : filtersListResponse.response.data == null
              ? Text('No filters')
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        childAspectRatio: 1 / 1.2,
                        children: List.generate(
                            filtersListResponse.response.data.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              selectedCuisinesIndexes.contains(index)
                                  ? selectedCuisinesIndexes.remove(index)
                                  : selectedCuisinesIndexes.add(index);
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: selectedCuisinesIndexes.contains(index)
                                    ? const Color(0xFF6244E8)
                                    : Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.1),
                                      blurRadius: 15,
                                      offset: Offset(0, 5)),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: filtersListResponse.response
                                                    .data[index].imageName ==
                                                null
                                            ? CircularLoadingWidget(height: 50)
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  imageUrl: filtersListResponse
                                                      .response
                                                      .data[index]
                                                      .imageName,
                                                  placeholder: (context, url) =>
                                                      CircularLoadingWidget(
                                                          height: 50),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(
                                                filtersListResponse
                                                    .response.data[index].name,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        selectedCuisinesIndexes
                                                                .contains(index)
                                                            ? Colors.white
                                                            : const Color(
                                                                0xFF6244E8),
                                                    fontFamily:
                                                        'Montserrat-Bold'),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: const Color(0xFF6244E8))),
                          onPressed: () {
                            var cuisines = null;
                            if (widget.cuisinesFiltersListener != null) {
                              if (selectedCuisinesIndexes != null &&
                                  selectedCuisinesIndexes.isNotEmpty) {
                                cuisines = List<Cuisine>();
                                for (int index in selectedCuisinesIndexes) {
                                  cuisines.add(
                                      filtersListResponse.response.data[index]);
                                }
                              }
                              widget.cuisinesFiltersListener
                                  .onCuisinesSelected(cuisines);
                            }
                            Navigator.pop(context);
                          },
                          color: const Color(0xFF6244E8),
                          textColor: Colors.white,
                          child: Text(S.of(context).submit, style: TextStyle(fontSize: 13)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            selectedCuisinesIndexes.clear();
                            setState(() {});
                          },
                          child: Text("Clear selection",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF6244E8))),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
