class AddToFavoriteRequest{
  String id;
  String type;

  AddToFavoriteRequest({this.id, this.type});

  AddToFavoriteRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map toMap() {
    var map = new Map<String,dynamic>();
    map['id'] = id;
    map['type'] = type;
    return map;
  }
}