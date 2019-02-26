import 'dart:io';

import 'package:cactime/database/database_helper.dart';
import 'package:cactime/desireList.dart';
import 'package:cactime/editDay.dart';
import 'package:cactime/editDesireList.dart';
import 'package:cactime/editMainDay.dart';
import 'package:cactime/model/PastData.dart';
import 'package:cactime/newDay.dart';
import 'package:cactime/util/desire.dart';
import 'package:cactime/util/desireWidget.dart';
import 'package:cactime/util/notification.dart';
import 'package:cactime/util/preferences.dart';
import 'package:cactime/util/weekname.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cactime/util/toast.dart';
import 'package:cactime/model//userdata.dart' as userdata;


int indexType = 0;
int indexOneType = 0;
notification notificationclass = new notification();
String logOutMsg = "會員登入";
String difference = "";
String isYearButton = "年";
bool isYear = false;
preferences preferencesclass = new preferences();


class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class Choice {
  const Choice({this.title, this.number});

  final String title;
  final int number;
}

class mainIndex extends StatefulWidget {
  mainIndex(this.uid);
  final String title = "人生倒數計時器";
  final String uid;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: '過去'),
    new Tab(text: '未來'),
  ];

  @override
  MainIndex createState() => MainIndex();
}

const List<Choice> choices = const <Choice>[
  const Choice(title: "編輯人生倒數", number: 0),
  const Choice(title: "編輯背景", number: 1),
  const Choice(title: "編輯願望", number: 2),
];


class MainIndex extends State<mainIndex> {
  var lifeDay = Text("",style: TextStyle(
    fontSize: 60.0,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(5.0,5.0),
        blurRadius: 5.0,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ],
  ));
  toast toastclass = new toast();
  drawerWidget drawerwidget = new drawerWidget();
  weekname weeknameclass = new weekname();
  List<PastData> pastDataList = new  List<PastData>();
  List<PastData> futureDataList = new  List<PastData>();
  FirebaseApp app;
  FirebaseDatabase database;
  DatabaseReference itemRef;

  Choice selectedChoice = choices[0]; // The app's "state".

  //更多
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      selectedChoice = choice;
      if(selectedChoice.number == 0){
        Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
          return new EditMainDay();
        })).then((String result){
          if(result != null){
            int deathYesr = 76;
            if(userdata.Sex == "男"){
              deathYesr = 76;
            }
            else if(userdata.Sex == "女"){
              deathYesr = 81;
            }

            int allDeathYesr = deathYesr + userdata.mYear;

            DateTime selectedDate = new DateTime(allDeathYesr, userdata.mMonth, userdata.mDay);
            DateTime date = DateTime.now();
            date = new DateTime(date.year, date.month, date.day);

            difference = selectedDate.difference(date).inDays.toString();


            if(selectedDate.difference(date).inDays <=0){
              notificationclass.deleteNotification(49522011);
              difference = "0";
            }
            toastclass.showToast(difference);
            setLifeDay(difference+"天");

            if(userdata.uid != "nologin84598349"){
              userdata.setDesireListMap();
              itemRef.child(userdata.uid).set(userdata.toJson());
            }
          }
        });
      }
      else if(selectedChoice.number == 2){
        Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
          return new EidtDesireListActivity();
        })).then((String result){
          if(result != null){
            if(userdata.uid != "nologin84598349"){
              userdata.setDesireListMap();
              itemRef.child(userdata.uid).set(userdata.toJson());
            }
            //widget.setDesirelist(result);
          }
        });
      }
    });
  }

  //載入時間資料
  void setData(BuildContext context){
    setState(() {
      if(indexType == 0){
        DatabaseHelper dbHelperPastData = new DatabaseHelper();
        dbHelperPastData.getPastData(this, context);
        indexType = 1;
      }
    });
  }

  //塞入目前壽命
  void setLifeDay(String difference){
    setState(() {
      lifeDay = Text(difference, style: TextStyle(
        fontSize: 60.0,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(5.0,5.0),
            blurRadius: 5.0,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ],
      ));
    });
  }

  String checkDay(int type, PastData pastData){
    DateTime dbDay = new DateTime(pastData.itemYear, pastData.itemMonth, pastData.itemDay);
    DateTime date2 = DateTime.now();
    date2 = new DateTime(date2.year, date2.month, date2.day);
    String day = "";
    if(type == 0){
      day = date2.difference(dbDay).inDays.toString();
    }
    else{
      day = dbDay.difference(date2).inDays.toString();
    }
    return day;
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

    itemRef = database.reference().child('Users');
    test(userdata.uid);

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
    itemRef.child(uid).onValue.listen((Event event) {
      setState(() {
        DatabaseError _error = null;
        var _counter = event.snapshot.value;

        if(_counter != null){

          bool isYear =  _counter["isYear"];
          bool isSmoking =  _counter["isSmoking"];
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
          userdata.isSmoking = isSmoking;

          preferencesclass.setString("userName", userName);
          preferencesclass.setInt("mYear", mYear);
          preferencesclass.setInt("mMonth", mMonth);
          preferencesclass.setInt("mDay", mDay);
          preferencesclass.setBool("isYear", isYear);
          preferencesclass.setBool("isSmoking", isSmoking);
          preferencesclass.setString("sex", sex);
          preferencesclass.setString("uid", uid);

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
    setData(context);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurple,
        title: new Text(widget.title),
          actions: <Widget>[
      // action button
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.skip(0).map((Choice choice) {
                  return PopupMenuItem<Choice>(
                    value: choice,
                    child: Text(choice.title),
                  );
                }).toList();
              },
            ),
    // action button
  ]

      ),
      drawer: drawerwidget.getDrawerWidget(context, userdata.userName, logOutMsg), //侧边栏按钮Drawer
      body: new DefaultTabController(
        length: widget.myTabs.length,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Stack(
                      alignment: FractionalOffset.topLeft,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Image.asset(
                                  'images/bg_private.jpg',
                                  height: 170.0, fit: BoxFit.cover),
                            ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child:

                        Row(
                          mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text("您的壽命剩餘", style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                              new MaterialButton(
                                minWidth: 35.0,
                                height: 35.0,
                                child: Text((isYearButton),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    )),
                                color: Colors.deepPurple,
                                splashColor: Colors.black12,
                                  onPressed: () {
                                    if(!isYear){
                                      isYearButton = "日";
                                      isYear= true;
                                      int allDay = int.parse(difference);
                                      double dbYear = allDay/365 ;
                                      int overDay = allDay - (dbYear.toInt()*365);
                                      String overYear = dbYear.toInt().toString() +"年"+overDay.toString()+"天";
                                      setLifeDay(overYear);
                                    }
                                    else{
                                      isYearButton = "年";
                                      isYear= false;
                                      setLifeDay(difference+"天");
                                    }
                                    preferencesclass.setBool("isYear", isYear);
                                    userdata.isYear = isYear;
                                    if(userdata.uid != "nologin84598349"){
                                      itemRef.child(userdata.uid).set(userdata.toJson());
                                    }
                                  },
                              )

                            ]),),
                        new Align(
                            alignment: FractionalOffset.center,
                            heightFactor:1.9 ,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  lifeDay,
                                ])),
                      ],
                    ),
                ),
              ],
            ),
            new Stack(
              children: <Widget>[
                new TabBar(
                  tabs: widget.myTabs,
                  indicatorColor: const Color(0xFFff7800),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.deepPurple,
                  labelStyle: new TextStyle(fontSize: 16.0),
                  unselectedLabelColor: Colors.black,
                ),

                new Padding(
                  padding: const EdgeInsets.only(top: 39.0),
                  child: new Divider(
                    color: Colors.grey,
                    height: 16.0,
                  ),
                ),
              ],
            ),
            new Expanded(
              child: new TabBarView(
                children: [
                  Scaffold(floatingActionButton: new FloatingActionButton(
                      elevation: 0.0,
                      backgroundColor: const Color(0xFFff7800),
                      child: new Icon(Icons.add),
                      onPressed: (){
                        bool isOk = true;
                        if(userdata.uid == "nologin84598349"){
                          if(pastDataList.length >= 1){
                            toastclass.showToast("請加入會員以便享有更多倒數日");
                            isOk = false;
                          }
                        }
                        if(isOk){
                          Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new NewDay(0);
                          })).then((String result){
                            if(result != null){
                              indexType = 0;
                              setData(context);
                            }
                          });
                        }
                      }
                  ),
                  body: ListView.separated(
                    itemCount: pastDataList.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(height:0, color: Colors.black),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: false,
                        leading: null,//左侧首字母图标显示，不显示则传null
                        title: new Text(pastDataList[index].itemName, style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        )),//子item的标题
                        subtitle: new Text("目標日："+pastDataList[index].itemMonth.toString()+"月 "+pastDataList[index].itemDay.toString()+","+pastDataList[index].itemYear.toString()+weeknameclass.getWeekName(pastDataList[index].itemWeekDay-1), style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text("過"+checkDay(0, pastDataList[index])+"天", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            )), new Icon(Icons.chevron_right)]),
                        onTap: (){
                          Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new EditDay(0, pastDataList[index]);
                          })).then((String result){
                            if(result != null){
                              indexType = 0;
                              setData(context);
                            }
                          });
                        },
                      );
                    },
                  )),
                  Scaffold(floatingActionButton: new FloatingActionButton(
                      backgroundColor: const Color(0xFFff7800),
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      onPressed: (){
                        bool isOk = true;
                        if(userdata.uid == "nologin84598349"){
                          if(futureDataList.length >= 1){
                            toastclass.showToast("請加入會員以便享有更多倒數日");
                            isOk = false;
                          }
                        }

                        if(isOk){
                          Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new NewDay(1);
                          })).then((String result){
                            if(result != null){
                              indexType = 0;
                              setData(context);
                            }
                          });
                        }


                      }
                  ), body: ListView.separated(
                    itemCount: futureDataList.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(height:0, color: Colors.black),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: false,
                        leading: null,//左侧首字母图标显示，不显示则传null
                        title: new Text(futureDataList[index].itemName, style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        )),//子item的标题
                        subtitle: new Text("目標日："+futureDataList[index].itemMonth.toString()+"月 "+futureDataList[index].itemDay.toString()+","+futureDataList[index].itemYear.toString()+weeknameclass.getWeekName(futureDataList[index].itemWeekDay-1), style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text("剩"+checkDay(1, futureDataList[index])+"天", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            )), new Icon(Icons.chevron_right)]),
                        onTap: (){
                          Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new EditDay(1, futureDataList[index]);
                          })).then((String result){
                            if(result != null){
                              indexType = 0;
                              setData(context);
                            }
                          });
                        },
                      );
                    },
                  )),
                ],
              ),
            ),

          ],

        ),

      ),
    );
  }

  @override
  void initState() {

    if(userdata.uid != "nologin84598349"){
      logOutMsg = "會員登出";
    }

    int deathYesr = 76;
    if(userdata.Sex == "男"){
      deathYesr = 76;
    }
    else if(userdata.Sex == "女"){
      deathYesr = 81;
    }

    int allDeathYesr = deathYesr + userdata.mYear;

    DateTime selectedDate = new DateTime(allDeathYesr, userdata.mMonth, userdata.mDay);
    DateTime date = DateTime.now();
    date = new DateTime(date.year, date.month, date.day);
    difference = selectedDate.difference(date).inDays.toString();


    if(selectedDate.difference(date).inDays <=0){
      notificationclass.deleteNotification(49522011);
      difference = "0";
    }
    toastclass.showToast(difference);
    setLifeDay(difference+"天");
    getDesireList();
    super.initState();
  }


}


