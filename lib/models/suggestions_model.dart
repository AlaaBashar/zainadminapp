

import 'package:zainadminapp/models/user_model.dart';

import '../utils.dart';

class SuggestionModel {
  String? id;

  String? title;
  String? des;

  DateTime? date;

  UserApp? user;
  String? userUid;

  SuggestionStatus? suggestionsStatus;

  SuggestionModel(
      {this.id,
        this.title,
        this.des,
        this.date,
        this.user,
        this.userUid,
        this.suggestionsStatus});

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json["id"],
      title: json["title"],
      des: json["des"],
      userUid: json["userUid"],
      suggestionsStatus: enumValueFromString(
        json["suggestionsStatus"],
        SuggestionStatus.values,
        onNull: SuggestionStatus.Pending,
      ),
      date: DateTime.parse(json["date"]),
      user: UserApp.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "des": this.des,
      "userUid": this.userUid,
      "suggestionsStatus": getStringFromEnum(this.suggestionsStatus!),
      "date": this.date!.toIso8601String(),
      "user": this.user!.toJson(),
    };
  }
}

enum SuggestionStatus { Pending, Approve, Rejected }
