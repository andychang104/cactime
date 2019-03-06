import 'package:cactime/generated/i18n.dart';
import 'package:cactime/util/system.dart';
import 'package:flutter/cupertino.dart';

class localdata {
  //取性別選單
  List<System> getSystemList(BuildContext context) {
    List<System> systemList = <System>[
      System(S.of(context).indexMr),
      System(S.of(context).indexMiss),
    ];
    return systemList;
  }

  //取手機日期時間
  String getTime() {
    DateTime now = new DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int hour = now.hour;
    int minute = now.minute;
    String time = "$year-$month-$day $hour:$minute";
    return time;
  }
}