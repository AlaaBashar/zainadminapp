import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/admin_model.dart';
import 'Fcm.dart';
import 'api.dart';

class Auth{
  Auth._();

  static AdminApp? currentAdmin ;



  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<AdminApp?> loginByEmailAndPass(
      { String? email,String? password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email ?? '', password: password ?? '');

      return await Api.getAdminFromUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {

      if (e.code == "user-not-found") {
        return Future.error('لا يوجد سجل لهذا البريد الإلكتروني');
      }

      if(e.code == "invalid-email") {
        return Future.error('عنوان البريد الإلكتروني منسق بشكل سيئ');
      } else {
        return Future.error('البريد الالكتروني او كلمة المرور غير صحيحة');
      }
    }
  }
  static Future forgotPassword(String email) async {

    print('======== $email');
    try{
      await _auth.sendPasswordResetEmail(email: email);

    }on FirebaseAuthException catch (e){
      if (e.code == "user-not-found") {
        return Future.error('لا يوجد سجل لهذا البريد الإلكتروني');
      }

      if(e.code == "invalid-email") {
        return Future.error('عنوان البريد الإلكتروني منسق بشكل سيئ');
      }

    }

  }

  static Future updateUserInPref(AdminApp user) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map userMap ;

    userMap = user.toJson();

    String userJson = json.encode(userMap);

    currentAdmin = user;
    Fcm.subscribeToTopic('admin');

    prefs.setString('Admin', userJson);
  }

  static Future removeUserFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Admin');
  }

  static Future<AdminApp?> getUserFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonUser;
    try {
      jsonUser = prefs.getString('Admin')!;
    } catch (e) {
      print('****** ${e.toString()}');
      return null;
    }
    Map<String , dynamic> userMap = json.decode(jsonUser);

    return AdminApp.fromJson(userMap);
  }

  static Future logout()async{
    await _auth.signOut();
    Fcm.unSubscribeToTopic('admin');
    removeUserFromPref();
    currentAdmin = null ;
  }



}