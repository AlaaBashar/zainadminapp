
import '../utils.dart';

class ComplaintModel {
  String? id;

  String? userUid;

  String? imageUrl ;

  String? username ;

  String? userPhoneNumber ;

  String? userId ;

  String? title;

  String? des;

  DateTime? date;

  String? ministriesTitle ;

  String? ministriesId ;


  ComplaintStatus? complaintStatus;

  ComplaintModel(
      {this.id,
        this.userUid,
        this.title,
        this.des,
        this.date,
        this.complaintStatus,
        this.username,
        this.userPhoneNumber,
        this.userId,
        this.imageUrl,
        this.ministriesId,
        this.ministriesTitle});

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json["id"],
      userUid: json["userUid"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      username: json["username"],
      ministriesId: json["ministriesId"],
      ministriesTitle: json["ministriesTitle"],
      userPhoneNumber: json["userPhoneNumber"],
      userId: json["userId "],
      des: json["des"],
      date: DateTime.parse(json["date"]),
      complaintStatus: enumValueFromString(
          json["complaintStatus"], ComplaintStatus.values,
          onNull: ComplaintStatus.Pending),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "userUid": this.userUid,
      "title": this.title,
      "imageUrl": this.imageUrl,
      "username": this.username,
      "ministriesTitle": this.ministriesTitle,
      "ministriesId": this.ministriesId,
      "userPhoneNumber": this.userPhoneNumber,
      "userId": this.userId,
      "des": this.des,
      "date": this.date!.toIso8601String(),
      "complaintStatus": getStringFromEnum(this.complaintStatus!),
    };
  }
}

enum ComplaintStatus { Pending, InProgress, Completed, Canceled }

