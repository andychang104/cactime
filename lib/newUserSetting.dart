import 'package:cactime/mainIndex.dart';
import 'package:cactime/util/localdata.dart';
import 'package:cactime/util/system.dart';
import 'package:cactime/util/toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


localdata localdataclass = new localdata();


class newUserSetting extends StatefulWidget {
  newUserSetting(this.uid);

  final String title = "人生倒數設定";
  final String uid;
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

  DateTime selectedDate = DateTime.now();
  String birthday = "請選擇生日";

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1000, 1),
        lastDate: DateTime(5000));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        birthday =
            selectedDate.year.toString() + "/" + selectedDate.month.toString() +
                "/" + selectedDate.day.toString();
        test = Colors.black;
      });
  }

  void onChanged(bool value) {
    setState(() {
      isCheck = value;
    });
  }


  @override
  Widget build(BuildContext context) {
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
                        //controller: new TextEditingController(text: widget.msg1),
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
                                  selectDate(context);
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 10.0, right: 8.0),
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

