import 'package:cactime/database/database_helper.dart';
import 'package:cactime/model/PastData.dart';
import 'package:cactime/util/notification.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

List<String> dayNameList =  new List<String>();
List<String> dayNumberList =  new List<String>();
toast toastclass = new toast();
notification notificationclass = new notification();
preferences preferencesclass = new preferences();
var newDayText = new RichText(text: new TextSpan(text: ""));
var dayNameEdit = TextEditingController(text: "");


class NewDay extends StatefulWidget {
  NewDay(this.type);
  String title = "";
  final int type;

  @override
  newDay createState() => newDay();
}

class newDay extends State<NewDay> {
  bool valueTop = false;
  bool valuePush = false;

  void onChangedTop(bool value){
    setState(() {
      valueTop = value;
    });
  }

  void onChangedPush(bool value){
    setState(() {
      valuePush = value;
    });
  }

  var dayTextColor = Colors.black54;

  DateTime selectedDate = DateTime.now();
  String newDayTextHint = "請選擇倒數日期";
  int year = DateTime.now().year;
  int month = DateTime.now().month;
  int day = DateTime.now().day;

  Future<Null> androidSelectDate(BuildContext context, int type) async {

    DateTime picked;
    if(type == 0){
      picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1000, 1),
          lastDate: DateTime.now());
    }
    else{
      picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate:  DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
          lastDate: DateTime(3000 , 1));
    }

    if (picked != null)
      setState(() {
        selectedDate = picked;
        year = selectedDate.year;
        month = selectedDate.month;
        day = selectedDate.day;
        newDayTextHint = year.toString() + "/" + month.toString() + "/" + day.toString();
        dayTextColor = Colors.black;
      });
  }

  Future<Null> iosSelectDate(BuildContext context, int type) async {

    DateTime minTime;
    DateTime maxTime;

    if(type == 0){
      minTime = DateTime(1000, 1);
      maxTime = DateTime.now();
    }
    else{
      minTime = DateTime.now();
      maxTime = DateTime(3000, 1);
    }

    DatePicker.showDatePicker(context, showTitleActions: true, minTime: minTime,  maxTime: maxTime, onChanged: (date) {
    }, onConfirm: (date) {
      setState(() {
        selectedDate = date;
        year = selectedDate.year;
        month = selectedDate.month;
        day = selectedDate.day;
        newDayTextHint = year.toString() + "/" + month.toString() + "/" + day.toString();
        dayTextColor = Colors.black;
      });
    }, currentTime: DateTime(year, month, day), locale: LocaleType.zh);
  }


  //錯誤訊息確認
  String checkErrorMsg() {
    String errorMsg = "";
    if(dayNameEdit.text.length == 0){
      errorMsg = "事件";
    }
    if(newDayTextHint == "請選擇倒數日期"){
      if(errorMsg.length != 0){
        errorMsg = errorMsg + "、";
      }
      errorMsg = errorMsg + "倒數日期";
    }

    if(errorMsg.length != 0){
      errorMsg = errorMsg+"未填寫，請您重新確認";
    }
    return errorMsg;
  }

  //顯示錯誤訊息Dialog
  Future<Null> showMsgDialog(String msg) async {
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text("訊息"),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(msg),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('確定'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    )) {
    }
  }


  @override
  void initState() {
    notificationclass.setNotificationsPlugin();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    if(widget.type == 0){
      widget.title = "新增紀念日";
    }
    else{
      widget.title = "新增倒數日";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.title),
      ),
      body: new Container(
        margin: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      "事件：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: new TextField(
                          controller: dayNameEdit,
                          decoration: InputDecoration(
                            hintText: "請輸入倒數事件名稱",
                            border: new UnderlineInputBorder(),
                          ),
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      "日期：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: newDayText = new RichText(
                          text: new TextSpan(
                              text: newDayTextHint,
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: dayTextColor,
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  if(isIos){
                                    iosSelectDate(context, widget.type);
                                  }
                                  else{
                                    androidSelectDate(context, widget.type);
                                  }
                                }),
                        ),
                      ),
                    ),
                    new Icon(Icons.chevron_right),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      "置頂：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Text(""),
                      ),
                    ),
                    new Switch(value: valueTop, onChanged: (bool value) {onChangedTop(value); },),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      "通知：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new Text(""),
                      ),
                    ),
                    new Switch(value: valuePush, onChanged: (bool value) {onChangedPush(value); },),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 10.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new MaterialButton(
                        height: 45.0,
                        child: Text("完成",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            )),
                        color: Colors.deepPurple,
                        elevation: 4.0,
                        textColor: Colors.white,
                        splashColor: Colors.black12,
                        onPressed: () {
                          String errorMsg = checkErrorMsg();

                          if(errorMsg.length != 0){
                              showMsgDialog(errorMsg);
                          }
                          else{
                            DateTime date2 = DateTime.now();
                            String time =  date2.month.toString() + date2.day.toString() + date2.hour.toString() + date2.minute.toString() + date2.second.toString();
                            String difference = "";
                            String tableName = "";
                            if(widget.type == 0){
                              tableName = "pastData";
                              difference = date2.difference(selectedDate).inDays.toString();

                            }
                            else{
                              tableName = "futureData";
                              difference = selectedDate.difference(date2).inDays.toString();
                            }

                            notificationclass.showNotification(dayNameEdit.text, int.parse(time), widget.type);

                            var dbHelper = DatabaseHelper();
                            PastData pastData = new PastData(dayNameEdit.text, year, month, day, valueTop.toString(), valuePush.toString(), difference, selectedDate.weekday);
                            pastData.setUserId(int.parse(time).toString());
                            dbHelper.savePastData(pastData,  tableName);
                            Navigator.pop(context, tableName);
                            print(time);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

