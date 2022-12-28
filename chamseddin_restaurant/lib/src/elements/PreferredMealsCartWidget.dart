import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';

import '../helpers/refresh_cart_listener.dart';
import '../models/Meals.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';
import 'PreferredMealCartWidget.dart';

class PreferredMealsCartWidget extends StatefulWidget {
  final String type;
  final String title;
  final String diningId;
  final int restaurantId;
  final RefreshCartListener refreshCartListener;
  PageBar pageBar;

  PreferredMealsCartWidget(this.title, this.type, this.diningId,
      this.restaurantId, this.refreshCartListener, {Key key, this.pageBar}) : super(key: key);

  @override
  _PreferredMealsCartWidgetState createState() =>
      _PreferredMealsCartWidgetState();
}

class _PreferredMealsCartWidgetState extends State<PreferredMealsCartWidget> {
  List<Meal> preferredMealsList;
  int _current = 0;

  void getPreferredMeals() async {
    getPreferredMealsForHome().then((value) {
      preferredMealsList = value.response.data;
      setState(() {});
    });
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
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        title: Text(
          widget.title,
          maxLines: 1,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat-Regular',
            fontSize: 19,
          ),
        ),
      ),
      getMeals()
    ]);
  }

  Widget getMeals() {
    if (preferredMealsList == null) {
      return CircularLoadingWidget(height: 50);
    }
    if (preferredMealsList.isEmpty)
      return Container(

        child: Text("No Data"),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      );
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: preferredMealsList.length,
        itemBuilder: (context, index) {
          return PreferredMealCartWidget(
              preferredMealsList[index], widget.restaurantId, widget.refreshCartListener, pageBar: widget.pageBar);
        },
      ),
    );
  }
}
