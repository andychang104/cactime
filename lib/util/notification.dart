import 'package:cactime/generated/i18n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

class notification{

  void setNotificationsPlugin(){
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload)  {
    if (payload != null) {
    }
  }

  //新增本地推播
  showNotification(String msg, int id, int type, BuildContext context) async{
    var time = new Time(8, 0, 0);
    var androidPlatformChannelSpecifics =
    new AndroidNotificationDetails('channel id',
        'Death Day', 'description');
    var iOSPlatformChannelSpecifics =
    new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        'show daily title',
        getPlshMsg(msg, type, context),
        time,
        platformChannelSpecifics);
  }

  String getPlshMsg(String msg, int type, BuildContext context){
    if(type == 0){
      msg += S.of(context).plshMsg1;
    }
    else if(type == 1){
      msg += S.of(context).plshMsg2;
    }
    else if(type == 99){
      msg += S.of(context).plshMsg3;
    }
    return msg;
  }

  //刪除本地推播
  deleteNotification(int id) async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

}