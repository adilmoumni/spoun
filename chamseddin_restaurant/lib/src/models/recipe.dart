class Recipe {
  int recipeId;
  String name;
  double price;
  bool isSelected = false;
  int quantity = 1;

  Recipe({this.recipeId, this.name, this.price});

  Recipe.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'] == null ? 1 : json['quantity'] is String
        ? int.parse(json['quantity'])
        : json['quantity'];
    recipeId = json['recipe_id'] is String
        ? int.parse(json['recipe_id'])
        : json['recipe_id'];
    name = json['name'];
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'] is String
            ? double.parse(json['price'])
            : json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity.toString();
    data['recipe_id'] = this.recipeId;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
