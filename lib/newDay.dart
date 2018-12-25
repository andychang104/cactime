import 'package:cactime/mainIndex.dart';
import 'package:cactime/util/localdata.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


localdata localdataclass = new localdata();


class NewDay extends StatefulWidget {
  NewDay(this.type);
  String title = "";
  final int type;
  RichText newDayText = new RichText(text: new TextSpan(text: ""));
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
  String newDayText = "請選擇倒數日期";
  int year = 2008;
  int month = 12;
  int day = 31;

  Future<Null> androidSelectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1000, 1),
        lastDate: DateTime(5000));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        newDayText =
            selectedDate.year.toString() + "/" + selectedDate.month.toString() +
                "/" + selectedDate.day.toString();
        dayTextColor = Colors.black;
      });
  }

  Future<Null> iosSelectDate(BuildContext context) async {
    DatePicker.showDatePicker(context, showTitleActions: true, onChanged: (date) {
    }, onConfirm: (date) {
      setState(() {
        selectedDate = date;
        year = selectedDate.year;
        month = selectedDate.month;
        day = selectedDate.day;
        newDayText = selectedDate.year.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.day.toString();
        dayTextColor = Colors.black;
      });
    }, currentTime: DateTime(year, month, day), locale: LocaleType.zh);
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
                        //controller: new TextEditingController(text: widget.msg1),
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
                        child: widget.newDayText = new RichText(
                          text: new TextSpan(
                              text: newDayText,
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: dayTextColor,
                              ),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  if(isIos){
                                    iosSelectDate(context);
                                  }
                                  else{
                                    androidSelectDate(context);
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => mainIndex("")),
                          );
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

