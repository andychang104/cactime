import 'dart:convert';
import 'dart:io';

import 'package:cactime/mainIndex.dart';
import 'package:cactime/model/userdata.dart';
import 'package:cactime/newUserSetting.dart';
import 'package:cactime/util/alllogin.dart';
import 'package:cactime/util/desire.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/progressdialog.dart';
import 'package:cactime/util/toast.dart';
import 'package:cactime/util/desireDialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'generated/i18n.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cactime/model//userdata.dart' as userdata;
import 'package:cactime/desireList.dart';


preferences preferencesclass = new preferences();
toast toastclass = new toast();
List<String> selectedCities = [];
alllogin loginclass = new alllogin();
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String userEmail = "";
bool isEmailCheck = false;


class Index extends StatefulWidget {
  @override
  Test createState() => Test();
}

class Test extends State<Index> {
  DatabaseReference itemRef;
  FirebaseDatabase database;
  FirebaseApp app;
  int loginType;
  var userEmailEdit = TextEditingController(text: userEmail);
  var userpasswordEdit = TextEditingController(text: "");

  void onChanged(bool value) {
    setState(() {
      isEmailCheck = value;
      preferencesclass.setBool("isEmailCheck", isEmailCheck);
    });
  }


  Future getDesireList() async {
    app = await FirebaseApp.configure(
      name: 'death-day-ea0ce',
      options: Platform.isIOS
          ? const FirebaseOptions(
        googleAppID: '1:725551685265:ios:1ab93789cfc10fe3',
        gcmSenderID: '725551685265',
        databaseURL: 'https://death-day-ea0ce.firebaseio.com',
      )
          : const FirebaseOptions(
        googleAppID: '1:725551685265:android:1ab93789cfc10fe3',
        apiKey: 'AIzaSyBFxNXe554VzPgiNSFCQpm49pZj46qgOoo',
        databaseURL: 'https://death-day-ea0ce.firebaseio.com',
      ),
    );

    database = FirebaseDatabase(app: app);

    DatabaseReference DesireList = database.reference().child('DesireList');

    DesireList.onValue.listen((Event event) {
      setState(() {
        DatabaseError _error = null;
        var _counter = event.snapshot.value;

        if(_counter == null){

        }
        else{
          List<String> allDesireList = new List<String>();
          for(int i=0; i<_counter.length; i++){
            if(i!=0) {
              allDesireList.add(_counter[i]["desireName"]);
            }
          }
          userdata.allDesireList = allDesireList;
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        DatabaseError _error = error;
      });
    });
  }


  void test(String uid){
    itemRef = database.reference().child('Users');

    itemRef.child(uid).onValue.listen((Event event) {
      setState(() {
        DatabaseError _error = null;
        var _counter = event.snapshot.value;

        if(_counter == null){
          toastclass.showToast("該使用者尚未輸入資料");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => newUserSetting(uid, itemRef, 1)),
          );
        }
        else{

          bool isYear =  _counter["isYear"];
          int mDay =  _counter["mDay"];
          int mMonth =  _counter["mMonth"];
          int mYear =  _counter["mYear"];
          String sex =  _counter["sex"];
          String uid =  _counter["uid"];
          String userName =  _counter["userName"];

          var desireListMap = _counter["desireList"];
          List <desire> desireList = new List <desire>();
          if(desireListMap != null){
            for(int i=0; i<desireListMap.length; i++){
              desire item = new desire();
              item.desireName = desireListMap[i]["desireName"];
              item.isCheck = desireListMap[i]["isCheck"];
              desireList.add(item);
            }
          }
          userdata.isYear = isYear;
          userdata.mDay = mDay;
          userdata.mMonth = mMonth;
          userdata.mYear = mYear;
          userdata.Sex = sex;
          userdata.uid = uid;
          userdata.userName = userName;
          userdata.DesireList = desireList;

          Navigator.pop(context);
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => mainIndex("")),
          );
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      setState(() {
        DatabaseError _error = error;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.deepPurple,
          title: new Text(S.of(context).loginTitle),
          automaticallyImplyLeading: false),
      body: new Container(
        margin: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    new Text(
                      (S.of(context).loginMsg),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new TextField(
                        controller: userEmailEdit,
                        //controller: new TextEditingController(text: widget.msg1),
                        decoration: InputDecoration(
                          hintText: (S.of(context).loginEditMailHint),
                          border: new UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new TextField(
                        controller: userpasswordEdit,
                        //controller: new TextEditingController(text: widget.msg1),
                        decoration: InputDecoration(
                          hintText: (S.of(context).loginEditPasswordHint),
                          border: new UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    new Checkbox(
                      value: isEmailCheck,
                      onChanged: (bool value) {
                        //_isEmailCheck = value;
                        onChanged(value);
                      },
                      activeColor: Colors.deepPurple,
                    ),
                    Expanded(
                      flex: 1,
                      child: new RichText(
                        text: new TextSpan(
                            text: (S.of(context).loginTextCheck),
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                if (isEmailCheck) {
                                  onChanged(false);
                                } else {
                                  onChanged(true);
                                }
                              }),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 10.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: new MaterialButton(
                          height: 45.0,
                          child: Text((S.of(context).loginBtn),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )),
                          color: Colors.deepPurple,
                          elevation: 4.0,
                          textColor: Colors.white,
                          splashColor: Colors.black12,
                          onPressed: () async {
                            if (userEmailEdit.text.length == 0) {
                              toastclass.showToast("請輸入帳號");
                            } else if (userpasswordEdit.text.length == 0) {
                              toastclass.showToast("請輸入密碼");
                            } else {
                              if (isEmailCheck) {
                                preferencesclass
                                    .setString("userEmail",userEmailEdit.text);
                              } else {
                                preferencesclass
                                    .setString("userEmail","");
                              }

                              showDialog(
                                  context: context,
                                  child: new progressdialog().progress);

                              loginclass.loginFirebase(context,
                                  userEmailEdit.text, userpasswordEdit.text, this);
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: new MaterialButton(
                          height: 45.0,
                          child: Text((S.of(context).noLoginBtn),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              )),
                          color: Colors.deepPurple,
                          elevation: 4.0,
                          textColor: Colors.white,
                          splashColor: Colors.black12,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => newUserSetting("nologin84598349", null, 0)),
                            );

                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: new MaterialButton(
                        height: 45.0,
                        child: Text((S.of(context).loginLostPassword),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            )),
                        color: Colors.deepPurple,
                        elevation: 4.0,
                        textColor: Colors.white,
                        splashColor: Colors.black12,
                        onPressed: () {
                          loginclass.showPasswordDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 15.0, right: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: new SignInButton(
                          Buttons.Facebook,
                          onPressed: () {
                            loginclass.logInFaceBook(this);
                          },
                          mini: true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: new SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            loginclass.signInGoogle(this);
                          },
                          mini: true,
                        ),
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
    _prefs.then((SharedPreferences prefs) {
      isEmailCheck = prefs.getBool('isEmailCheck');
      if(isEmailCheck == null){
        isEmailCheck = false;
      }
    });

    _prefs.then((SharedPreferences prefs) {
      userEmail = prefs.getString("userEmail");
      if(userEmail == null){
        userEmail = "";
      }
      userEmailEdit = TextEditingController(text: userEmail);
    });
    getDesireList();
    super.initState();
  }


}

