//class userdata {
//   String uid;
//   int mYear;
//   int mMonth;
//   int mDay;
//   String userName;
//   String Sex;
//   bool isYear;
//   String Desire;
//   List<String> DesireList;
//}

import 'dart:convert';

import 'package:cactime/util/desire.dart';

String uid;
int mYear;
int mMonth;
int mDay;
String userName;
String Sex;
bool isYear;
bool isSmoking;
bool isMainPush;
String imageBg;


List<desire> DesireList;
List<Map> desireListMap;
List<String> allDesireList;


toJson(){
  return {
    "uid":uid,
    "mYear":mYear,
    "mMonth":mMonth,
    "mDay":mDay,
    "userName":userName,
    "sex":Sex,
    "isYear":isYear,
    "isSmoking":isSmoking,
    "desireList": desireListMap
  };
}

setDesireListMap(){
  desireListMap = new List<Map>();
  for(int i=0; i<DesireList.length; i++){
    Map<String, dynamic> item = Map();
    item["isCheck"] = DesireList[i].isCheck;
    item["desireName"] = DesireList[i].desireName;
    desireListMap.add(item);
  }
}



