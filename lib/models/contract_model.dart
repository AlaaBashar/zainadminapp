

import 'package:zainadminapp/models/user_model.dart';

class ContractModel {

  String? customerName;
  String? customerNumber;
  String? buildCode ;
  String? offer ;
  String? speed ;
  String? commitmentDuration;
  String? customerSignature;
  String? employeeName;
  String? id;
  DateTime? date;
  UserApp? user;
  String? userUid;

  ContractModel(
      {this.id,
        this.date,
        this.user,
        this.userUid,
        this.customerName,
        this.customerNumber,
        this.buildCode,
        this.offer,
        this.speed,
        this.commitmentDuration,
        this.customerSignature,
        this.employeeName,
      });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      customerName: json["customerName"],
      customerNumber: json["customerNumber"],
      buildCode: json["buildCode"],
      offer: json["offer"],
      speed: json["speed"],
      commitmentDuration: json["commitmentDuration"],
      customerSignature: json["customerSignature"],
      employeeName: json["employeeName"],
      id: json["id"],
      userUid: json["userUid"],
      date: DateTime.parse(json["date"]),
      user: UserApp.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "customerName": customerName,
      "customerNumber": customerNumber,
      "buildCode": buildCode,
      "offer": offer,
      "speed": speed,
      "commitmentDuration": commitmentDuration,
      "customerSignature": customerSignature,
      "employeeName": employeeName,
      "id": id,
      "userUid": userUid,
      "date": date!.toIso8601String(),
      "user": user!.toJson(),
    };
  }
}

