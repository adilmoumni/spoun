import '../models/Meals.dart';
import '../models/view_cart_response.dart';

class MealCustomizationArguments {
  final ViewCartFoodDetail foodDetail;
  final Meal meal;

  MealCustomizationArguments(this.foodDetail, this.meal);
}
