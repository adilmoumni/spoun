class SpecificInstructionsRequest {
  final String restaurant_id;
  final String instructions;

  SpecificInstructionsRequest(this.restaurant_id, this.instructions);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['restaurant_id'] = restaurant_id;
    map['instructions'] = instructions;
    return map;
  }
}
