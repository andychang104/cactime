import 'dart:async';
import 'dart:convert';
import 'package:cactime/model/Contact.dart';
import 'package:cactime/model/Data.dart';
import 'package:shared_preferences/shared_preferences.dart';

String string = "";
bool boolean = false;
List<String> stringList;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


class preferences {
  //存字串
  Future setString(String key, String string) async {
// obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setString(key, string);
  }

  //存布林
  Future setBool(String key, bool boolean) async {
// obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setBool(key, boolean);
  }

  //存數字
  Future setInt(String key, int intdata) async {
// obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
// set value
    prefs.setInt(key, intdata);
  }




}

