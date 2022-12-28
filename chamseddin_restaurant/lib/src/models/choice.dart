class Choice {
  int choiceId;
  String name;
  dynamic price;
  bool isSelected = false;

  Choice({this.name, this.price, this.isSelected =false});

  Choice.fromJson(Map<String, dynamic> json) {
    choiceId = json['choice_id'] == null
        ? null
        : json['choice_id'] is int
            ? json['choice_id']
            : int.parse(json['choice_id']);
    name = json['name'];
    isSelected = json['isSelected'] ?? false;

    price = json['price'] is int
        ? (json['price'] as int).toDouble()
        : json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['choice_id'] = this.choiceId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['isSelected'] = this.isSelected;
    return data;
  }
}
