import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Fcm {

  static  String _serverKey = "AAAAT9utabo:APA91bFgpHP6KsSqq5vEBrlVawoYomsWTfoo1fBCwvpjhNPQN0td1W5g96StMTbq7Q4aqWI8NETh8FAXjAMd4l4DKFuei-7epcHtjgohuue63eTxYi3FA8B1IXQpCXyNHzQCOFAFOiyL";

  static  FirebaseMessaging _fcm = FirebaseMessaging.instance;



  static subscribeToTopic(String topic) {
    _fcm.subscribeToTopic(topic);
  }

  static unSubscribeToTopic(String topic) {
    _fcm.unsubscribeFromTopic(topic);
  }


  static Future sendNotificationToUser(String title, String body, String topic) async {

    if(_serverKey.isEmpty){
      ///TODO add [_serverKey]
      return ;
    }

    String url = "https://fcm.googleapis.com/fcm/send";

    Map notificationObj = Map();

    notificationObj['title'] = title;
    notificationObj['body'] = body;

    var response = await http.post(Uri.parse(url), body: jsonEncode({
      "to": "/topics/$topic",
      "notification": notificationObj,
    }), headers: {
      "content-type": "application/json",
      "authorization": "key=$_serverKey"
    });



    debugPrint(" fcm response : ${response.statusCode}");

  }
}
