class AreasModel{

  String? state;
  bool? isBlocked;
  String? id;

  AreasModel({this.state,this.isBlocked,this.id});


  factory AreasModel.fromJson(Map<String, dynamic> json) {
    return AreasModel(
      state: json["state"],
      isBlocked: json["isBlocked"] ?? false,
      id: json["id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "state": state,
      "isBlocked": isBlocked ?? false,
      "id": id,

    };
  }


}