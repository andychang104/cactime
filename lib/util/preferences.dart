import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

String userEmail = "";
bool emailCheck = false;

class preferences {
  //存借用者帳號
  Future setUserEmail(String userEmail) async {
// obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setString('userEmail', userEmail);
  }

  //取借用者帳號
  String getUserEmail() {
    getuserEmail ();
    return userEmail;
  }

  Future getuserEmail () async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    userEmail = prefs.getString('userEmail');

  }


  //存記住帳號checkbox狀態
  Future setEmailCheck(bool emailCheck) async {
// obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setBool('emailCheck', emailCheck);
  }

  //取記住帳號checkbox狀態
  bool getEmailCheck() {
    getemailCheck ();
    return emailCheck;
  }

  Future getemailCheck () async {
    final prefs = await SharedPreferences.getInstance();
// Try reading data from the counter key. If it does not exist, return 0.
    emailCheck = prefs.getBool('emailCheck');
    if(emailCheck == null){
      emailCheck = false;
    };
  }

}