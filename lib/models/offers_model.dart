class OffersModel{

  String? price;
  String? speed;

  OffersModel({this.price, this.speed});


  factory OffersModel.fromJson(Map<String, dynamic> json) {
    return OffersModel(
      price: json["price"],
      speed: json["speed"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "price": this.price,
      "speed": this.speed,

    };
  }


}