import 'package:cactime/util/system.dart';

class localdata {
  //取性別選單
  List<System> getSystemList() {
    List<System> systemList = <System>[
      const System('男'),
      const System('女'),
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