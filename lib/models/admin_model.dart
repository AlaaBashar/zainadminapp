class AdminApp{

  String? uid ;
  String? email ;

  AdminApp({this.uid, this.email});

  factory AdminApp.fromJson(Map<String, dynamic> json) {
    return AdminApp(
      uid: json["uid"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": this.uid,
      "email": this.email,
    };
  }
}