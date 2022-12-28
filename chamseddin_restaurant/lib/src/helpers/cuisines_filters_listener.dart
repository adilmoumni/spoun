import '../models/filters_list_response.dart';

abstract class CuisinesFiltersListener {
  onCuisinesSelected(List<Cuisine> cuisines);
}
