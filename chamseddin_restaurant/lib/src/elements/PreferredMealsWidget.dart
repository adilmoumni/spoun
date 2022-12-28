import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/TextSize.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';

import '../constants.dart';
import '../elements/PreferredMealWidget.dart';
import '../models/Meals.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';

class PreferredMealsWidget extends StatefulWidget {
  final String type;
  final String title;
  final String diningId;
  final String restaurantId;
  PageBar pageBar;

  PreferredMealsWidget(this.title, this.type, this.diningId, this.restaurantId,
      {Key key, this.pageBar})
      : super(key: key);

  @override
  _PreferredMealsWidgetState createState() => _PreferredMealsWidgetState();
}

class _PreferredMealsWidgetState extends State<PreferredMealsWidget> {
  Response response;
  int _current = 0;

  void getPreferredMeals() async {
    if (widget.type == Constants.PREFERRED_MEALS_TYPE_HOME) {
      getPreferredMealsForHome().then((value) {
        response = value.response;
        // setState(() {});
        if (mounted) {
          setState(() => 'No Data');
        }
      });
    } else if (widget.type == Constants.PREFERRED_MEALS_TYPE_DINING_AREA) {
      getPreferredMealsForDiningArea(widget.diningId).then((value) {
        response = value.response;
        // setState(() {});

        if (mounted) {
          setState(() => 'No Data');
        }
      });
    } else if (widget.type == Constants.PREFERRED_MEALS_TYPE_RESTAURANT) {
      getPreferredMealsForRestaurant(widget.restaurantId).then((value) {
        response = value.response;
        // setState(() {});
        if (mounted) {
          setState(() => 'No Data');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPreferredMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        // tileColor: Colors.black,
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: TextSize.TEXT3),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat-Regular',
            fontSize: TextSize.TEXT3,
          ),
        ),
      ),
      getMeals()
    ]);
  }

  Widget getMeals() {
    if (response == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (response.data == null || response.data.isEmpty) {
      return Container(
        // color: Colors.black,
        height: 20,
        child: Text("No preferred meals"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );
    }

    final children = <Widget>[];
    for (var i = 0; i < response.data.length; i++) {
      children.add(PreferredMealWidget(
        response.data[i],
        response.data[i].restaurantId,
        pageBar: widget.pageBar,
      ));
    }
    return Column(children: [
      CarouselSlider(
        items: children,
        options: CarouselOptions(
            autoPlay: false,
            height: TextSize.MEAL_HEIGHT,
            enlargeCenterPage: true,
            // aspectRatio: 2.0,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: response.data.map((url) {
              int index = response.data.indexOf(url);
              return Container(
                width: TextSize.TEXT_PADDING1,
                height: TextSize.TEXT_PADDING1,
                margin: EdgeInsets.symmetric(
                    vertical: TextSize.TEXT, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? const Color(0xFF6244E8)
                      : const Color(0xFF6244E8).withOpacity(0.5),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ]);
  }
}
