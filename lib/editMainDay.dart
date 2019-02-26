import 'package:cactime/mainIndex.dart';
import 'package:cactime/util/localdata.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cactime/model//userdata.dart' as userdata;

localdata localdataclass = new localdata();
preferences preferencesclass = new preferences();
var userNameEdit = TextEditingController(text: "");


class EditMainDay extends StatefulWidget {
  String title = "編輯個人資料";
  RichText newDayText = new RichText(text: new TextSpan(text: ""));
  @override
  editMainDay createState() => editMainDay();
}

class editMainDay extends State<EditMainDay> {
  bool isCheck = false;
  System selectedSystem;
  bool valuePush = false;
  List<System> systemList = localdataclass.getSystemList();
  void onChangedPush(bool value){
    setState(() {
      valuePush = value;
    });
  }

  var dayTextColor = Colors.black;

  DateTime selectedDate = DateTime.now();
  String birthday = "請選擇生日";
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
        year = selectedDate.year;
        month = selectedDate.month;
        day = selectedDate.day;
        birthday =
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
        birthday = selectedDate.year.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.day.toString();
        dayTextColor = Colors.black;
      });
    }, currentTime: DateTime(year, month, day), locale: LocaleType.zh);
  }

  void onChanged(bool value) {
    setState(() {
      isCheck = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
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
                      "姓名：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: new TextField(
                          controller: userNameEdit,
                          decoration: InputDecoration(
                            hintText: "請輸入姓名",
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
                      "生日：",
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
                              text: birthday,
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
                      "性別：",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: new DropdownButton<System>(
                          hint: new Text("請選擇性別",
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          value: selectedSystem,
                          onChanged: (System newValue) {
                            setState(() {
                              selectedSystem = newValue;
                            });
                          },
                          items: systemList.map((System system) {
                            return new DropdownMenuItem<System>(
                              value: system,
                              child: new Text(
                                system.systemname,
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
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
                      "通知：(每日1次 8:00)",
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
                padding: const EdgeInsets.only(top: 4.0, right: 8.0),
                child: Row(
                  children: [
                    new Checkbox(value: isCheck, onChanged: (bool value) {
                      //_isEmailCheck = value;
                      onChanged(value);
                    }, activeColor: Colors.deepPurple,),
                    Expanded(
                      flex: 1,
                      child: new RichText(
                        text: new TextSpan(
                            text: "是否有抽菸習慣",
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                if (isCheck) {
                                  onChanged(false);
                                }
                                else {
                                  onChanged(true);
                                }
                              }),
                      ),
                    ),

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

                          preferencesclass.setString("userName", userNameEdit.text);
                          preferencesclass.setInt("mYear", year);
                          preferencesclass.setInt("mMonth", month);
                          preferencesclass.setInt("mDay", day);
                          preferencesclass.setString("sex", selectedSystem.systemname);
                          preferencesclass.setBool("isSmoking", isCheck);
                          preferencesclass.setBool("isMainPush", valuePush);

                          userdata.userName = userNameEdit.text;
                          userdata.mDay =  day;
                          userdata.mMonth =  month;
                          userdata.mYear =  year;
                          userdata.Sex =  selectedSystem.systemname;
                          userdata.isSmoking = isCheck;
                          userdata.isMainPush = valuePush;

                          Navigator.pop(context, "ok");
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => mainIndex("")),
//                          );
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

  @override
  void initState() {
    if(userdata.isMainPush !=null){
      valuePush = userdata.isMainPush;
    }
    if(userdata.isSmoking != null){
      isCheck = userdata.isSmoking;
    }

    userNameEdit = TextEditingController(text: userdata.userName);
    if(userdata.Sex == "男"){
      selectedSystem=systemList[0];
    }
    else {
      selectedSystem=systemList[1];
    }
    selectedDate = new DateTime(userdata.mYear, userdata.mMonth, userdata.mDay);
    year = userdata.mYear;
    month = userdata.mMonth;
    day = userdata.mDay;
    birthday = userdata.mYear.toString()+"/"+userdata.mMonth.toString()+"/"+userdata.mDay.toString();
    super.initState();
  }
}

