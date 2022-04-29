

import 'package:zainadminapp/models/user_model.dart';

class VisitsModel {
  String? gender;
  String? nationality;
  String? idType;
  String? dateOfBirth;
  String? firstName;
  String? secondName;
  String? thirdName;
  String? internalUsage;
  String? commitmentDuration;
  String? pricePerMonth;
  String? endVisit;
  String? id;
  DateTime? date;
  UserApp? user;
  String? userUid;

  VisitsModel(
      {this.gender,
      this.nationality,
      this.idType,
      this.dateOfBirth,
      this.firstName,
      this.secondName,
      this.thirdName,
      this.internalUsage,
      this.commitmentDuration,
      this.pricePerMonth,
      this.endVisit,
      this.id,
      this.date,
      this.user,
      this.userUid});

  factory VisitsModel.fromJson(Map<String, dynamic> json) {
    return VisitsModel(
      id: json["id"],
      nationality: json["nationality"],
      idType: json["idType"],
      dateOfBirth: json["dateOfBirth"],
      firstName: json["firstName"],
      secondName: json["secondName"],
      thirdName: json["thirdName"],
      internalUsage: json["internalUsage"],
      commitmentDuration: json["commitmentDuration"],
      pricePerMonth: json["pricePerMonth"],
      endVisit: json["endVisit"],
      userUid: json["userUid"],
      date: DateTime.parse(json["date"]),
      user: UserApp.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nationality": nationality,
      "idType": idType,
      "dateOfBirth": dateOfBirth,
      "firstName": firstName,
      "secondName": secondName,
      "thirdName": thirdName,
      "internalUsage": internalUsage,
      "commitmentDuration": commitmentDuration,
      "pricePerMonth": pricePerMonth,
      "endVisit": endVisit,
      "userUid": userUid,
      "date": date!.toIso8601String(),
      "user": user!.toJson(),
    };
  }
}

