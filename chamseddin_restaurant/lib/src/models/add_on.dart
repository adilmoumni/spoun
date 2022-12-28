class AddOn {
  String name;
  double price;
  bool isSelected = false;

  AddOn({this.name, this.price});

  AddOn.fromJson(Map<String, dynamic> json) {
    name = json['name'] is String ? json['name'] : json['name'].toString();
    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'] is String
            ? double.parse(json['price'])
            : json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}
