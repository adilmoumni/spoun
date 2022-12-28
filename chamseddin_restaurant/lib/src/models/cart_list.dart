import 'choice.dart';

class CartList {
  String list_name;
  List<Choice> choices;

  CartList({this.list_name, this.choices});

  CartList.fromJson(Map<String, dynamic> json) {
    list_name = json['list_name'];
    choices = json['choices'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['list_name'] = this.list_name;
    data['choices'] = this.choices;
    return data;
  }
}