import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/models/BottomNavigationBar.dart';
import '../TextSize.dart';

import '../elements/MealWidget.dart';
import '../models/Meals.dart';
import '../repository/meals_repository.dart';
import 'CircularLoadingWidget.dart';

class RestaurantsMealsListWidget extends StatefulWidget {
  final int categoryId;
  final int restaurantId;
  final BuildContext context;
  PageBar pageBar;

  RestaurantsMealsListWidget(this.context,this.categoryId, this.restaurantId, {Key key, this.pageBar}) : super(key: key);

  @override
  _RestaurantsMealsListWidgetState createState() =>
      _RestaurantsMealsListWidgetState();
}

class _RestaurantsMealsListWidgetState
    extends State<RestaurantsMealsListWidget> {
  Response response;

  void getMeals() async {
    response = null;
    getAllMealsForRestaurant(widget.categoryId, widget.restaurantId)
        .then((value) {
      response = value.response;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getMeals();
  }

  @override
  void didUpdateWidget(covariant RestaurantsMealsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    getMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: getRestaurantsWidget());
  }

  Widget getRestaurantsWidget() {
    if (response == null) {
      return Container(

        child: CircularLoadingWidget(height: 50),
        padding: EdgeInsets.symmetric(horizontal: TextSize.TEXT, vertical: 0),
      );
    }
    if (response.data == null || response.data.isEmpty)
      return Container(
        child: Text("No Meals"),
        padding: EdgeInsets.symmetric(horizontal: TextSize.TEXT, vertical: 0),
      );

    return ListView.builder(
      // separatorBuilder: (context, index) =>
      //     Divider(thickness: 2,color: Colors.black,),

      scrollDirection: Axis.vertical,
      itemCount: response.data.length,
      itemBuilder: (context, index) {
        return MealWidget(widget.context,response.data[index],widget.restaurantId, pageBar: widget.pageBar,);
      },
    );
  }
}
