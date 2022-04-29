

import '../utils.dart';

class UserApp {
  String? id, uid, name, password, email , phone;
  bool? isBlocked ;
  DateTime? date;

  Gender? gender;

  UserApp({
     this.id,
     this.uid,
     this.name,
      this.date,
     this.gender,
     this.email,
     this.password,
     this.phone,
    this.isBlocked,
  });

  factory UserApp.fromJson(Map<String, dynamic> json) {
    return UserApp(
      id: json["id"],
      uid: json["uid"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      isBlocked: json["isBlocked"] ?? false,
      password: json["password"],
      date: DateTime.parse(json["date"]),
      gender: enumValueFromString(json["gender"], Gender.values,
          onNull: Gender.Male),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "uid": this.uid,
      "name": this.name,
      "phone": this.phone,
      "isBlocked": this.isBlocked ?? false,
      "email": this.email,
      "password": '',
      "date": this.date!.toIso8601String(),
      "gender": getStringFromEnum(this.gender ?? Gender.Male),
    };
  }
}

enum Gender { Male, Female }
