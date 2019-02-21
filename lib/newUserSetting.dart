import 'package:cactime/mainIndex.dart';
import 'package:cactime/util/desireEditWidget.dart';
import 'package:cactime/util/localdata.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/system.dart';
import 'package:cactime/util/toast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cactime/model//userdata.dart' as userdata;

localdata localdataclass = new localdata();
desireEditWidget desireEditWidgetClass = new desireEditWidget();
preferences preferencesclass = new preferences();
var userNameEdit = TextEditingController(text: "");


class newUserSetting extends StatefulWidget {
  newUserSetting(this.uid, this.itemRef, this.type);

  final String title = "人生倒數設定";
  final String uid;
  final int type;
  final DatabaseReference itemRef;
  RichText birthdayText = new RichText(text: new TextSpan(text: ""));

  @override
  newUser createState() => newUser();
}

class newUser extends State<newUserSetting> {

  bool isCheck = false;
  System selectedSystem;
  List<System> systemList = localdataclass.getSystemList();
  toast toastclass = new toast();

  var test = Colors.black54;
  var desireTextColor = Colors.black54;

  DateTime selectedDate = DateTime.now();
  String birthday = "請選擇生日";
  String desirelist = "請選擇最想完成的願望";
  RichText desireText = new RichText(text: new TextSpan(text: ""));
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
        birthday = selectedDate.year.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.day.toString();
        test = Colors.black;
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
        test = Colors.black;
      });
    }, currentTime: DateTime(year, month, day), locale: LocaleType.zh);
  }

  void onChanged(bool value) {
    setState(() {
      isCheck = value;
    });
  }

  void setDesirelist(String msg){
    setState(() {
      if(msg.length == 0){
        desirelist = "請選擇最想完成的願望";
        desireTextColor = Colors.black54;
      }
      else{
        desirelist = msg;
        desireTextColor = Colors.black;
      }

    });
  }



  //錯誤訊息確認
  String checkErrorMsg() {
    String errorMsg = "";
    if(userNameEdit.text.length == 0){
      errorMsg = "姓名";
    }
    if(birthday == "請選擇生日"){
      if(errorMsg.length != 0){
        errorMsg = errorMsg + "、";
      }
      errorMsg = errorMsg + "生日";
    }
    if(selectedSystem != null){
      if(selectedSystem.systemname.length == 0){
        if(errorMsg.length != 0){
          errorMsg = errorMsg + "、";
        }
        errorMsg = errorMsg + "性別";
      }
    }
    else{
      if(errorMsg.length != 0){
        errorMsg = errorMsg + "、";
      }
      errorMsg = errorMsg + "性別";
    }

    if(widget.type != 0){
      if(userdata.DesireList != null){
        if(userdata.DesireList.length == 0){
          if(errorMsg.length != 0){
            errorMsg = errorMsg + "、";
          }
          errorMsg = errorMsg + "願望";
        }
      }
      else{
        if(errorMsg.length != 0){
          errorMsg = errorMsg + "、";
        }
        errorMsg = errorMsg + "願望";
      }
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
                        child: widget.birthdayText = new RichText(
                          text: new TextSpan(
                              text: birthday,
                              style: new TextStyle(
                                fontSize: 16.0,
                                color: test,
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
              desireEditWidgetClass.getdesireEditWidget(this, context, widget.type),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new MaterialButton(
                        height: 45.0,
                        child: Text("送出",
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

                            preferencesclass.setString("userName", userNameEdit.text);
                            preferencesclass.setInt("mYear", year);
                            preferencesclass.setInt("mMonth", month);
                            preferencesclass.setInt("mDay", day);
                            preferencesclass.setBool("isYear", false);
                            preferencesclass.setString("sex", selectedSystem.systemname);

                            userdata.userName = userNameEdit.text;
                            userdata.isYear =  false;
                            userdata.mDay =  day;
                            userdata.mMonth =  month;
                            userdata.mYear =  year;
                            userdata.Sex =  selectedSystem.systemname;
                            userdata.uid = widget.uid;

                            if(widget.type == 0){

                              preferencesclass.setString("uid", "nologin84598349");

                              Navigator.of(context).pushAndRemoveUntil(
                                  new MaterialPageRoute(builder: (context) => new mainIndex("")
                                  ), (route) => route == null);
                            }
                            else{

                              preferencesclass.setString("uid", widget.uid);
                              userdata.setDesireListMap();

                              print("USERDATA:"+userdata.toJson().toString());
                              widget.itemRef.child(widget.uid).set(userdata.toJson());
                            }
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

  @override
  void initState() {
    userdata.DesireList = null;
    super.initState();
  }
}

