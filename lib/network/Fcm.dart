import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Fcm {

  static  const String _serverKey = "AAAABJVXcy0:APA91bGRZnmviUwfOdQdKRJMF8X8mldUoELYB1DZ2UXVVE2Iio7dHLmprHncRIDSv2KkButbevjDFFfjH2bF_l4Yv3U5_XwkN3TVNIvJ88lPur_wym5Gph86GM2oQDOmv8-lDWOe31Ni";

  static  final FirebaseMessaging _fcm = FirebaseMessaging.instance;



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

    var response = await http.post(Uri.parse(url),
        body: jsonEncode({
          "to": "/topics/$topic",
          "notification": notificationObj,
        }),
        headers: {
          "content-type": "application/json",
          "authorization": "key=$_serverKey"
        });

    debugPrint(" fcm response : ${response.statusCode}");

  }
}
