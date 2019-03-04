import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cactime/database/database_helper.dart';
import 'package:cactime/editDay.dart';
import 'package:cactime/editDesireList.dart';
import 'package:cactime/editMainDay.dart';
import 'package:cactime/generated/i18n.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cactime/model//userdata.dart' as userdata;


int indexType = 0;
int indexOneType = 0;

String logOutMsg = "";
String difference = "";
String isYearButton = "";
String title = "";
String tabPast = "";
String tabfuture = "";
String mr = "";
String miss = "";
String day = "";

notification notificationclass = new notification();

bool isYear = false;
bool isInitState = false;

preferences preferencesclass = new preferences();

File croppedFile;

Uint8List userBgImageBytes;
Uint8List userImageBytes;

List<Choice> choices = [];

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
  final String uid;

  List<Tab> myTabs = <Tab>[
    new Tab(text: tabPast),
    new Tab(text: tabfuture),
  ];

  @override
  MainIndex createState() => MainIndex();
}

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

  Choice selectedChoice; // The app's "state".

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
            if(userdata.Sex == mr){
              deathYesr = 76;
            }
            else if(userdata.Sex == miss){
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
            setLifeDay(difference+day);

            if(userdata.uid != "nologin84598349"){
              userdata.setDesireListMap();
              itemRef.child(userdata.uid).set(userdata.toJson());
            }
          }
        });
      }
      else if(selectedChoice.number == 1){
        getImage(0);
      }
      else if(selectedChoice.number == 2){
        editDesire();
      }
    });
  }

  //編輯願望
  void editDesire(){
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

  File _image;

  Future getImage(int type) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = image;
    _cropImage(_image, type);

  }

  Future<Null> _cropImage(File imageFile, int type) async {
    double x = 1.0;
    double y = 1.0;

    if(type == 0){
      x = 1.9;
    }

    File croppedfile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: x,
      ratioY: y,
      maxWidth: 10000,
      maxHeight: 10000,
    );
    setState(() {
      if(croppedfile != null){
        croppedFile = croppedfile;
        List<int> imageBytes = croppedFile.readAsBytesSync();
        print(imageBytes);
        String base64Image = base64Encode(imageBytes);

        if(type == 0){
          preferencesclass.setString("imageBg", base64Image);
          userBgImageBytes = base64Decode(base64Image);
        }
        else if(type == 1){
          preferencesclass.setString("imageFace", base64Image);
          userImageBytes = base64Decode(base64Image);
        }
      }
      getBgImageWidget(type);

    });
  }

  Widget getBgImageWidget(int type){
    Widget desireItemWidget;

    if(type == 0){
      if(userBgImageBytes == null){
        desireItemWidget = Image.asset('images/bg_private.jpg', height: 170.0, fit: BoxFit.cover);
      }
      else{
        desireItemWidget = new Image.memory(userBgImageBytes, height: 170.0, fit: BoxFit.cover);
      }
    }
    else if(type == 1){

      if(userImageBytes == null){
        desireItemWidget = new CircleAvatar(backgroundImage: AssetImage('images/ic_launcher_140.png'));
      }
      else {
        desireItemWidget = new CircleAvatar(backgroundImage: MemoryImage(userImageBytes));
      }

    }

    return desireItemWidget;
  }

  //塞入預設文案
  void setText(BuildContext context){
    if(isInitState){
      logOutMsg = S.of(context).loginTitle;
      title = S.of(context).appName;
      tabPast = S.of(context).indexPast;
      tabfuture = S.of(context).indexFuture;
      mr = S.of(context).indexMr;
      miss = S.of(context).indexMiss;
      day = S.of(context).indexDay2;

      if(!isYear){
        isYearButton = S.of(context).indexYear;
      }
      else{
        isYearButton = S.of(context).indexDay;
      }
      if(userdata.uid != "nologin84598349"){
        logOutMsg = S.of(context).logoutTitle;
      }

      widget.myTabs = <Tab>[
        new Tab(text: tabPast),
        new Tab(text: tabfuture),
      ];

      int deathYesr = 76;
      if(userdata.Sex == mr){
        deathYesr = 76;
      }
      else if(userdata.Sex == miss){
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
      setLifeDay(difference+day);

      choices = <Choice>[
         Choice(title: S.of(context).actionSettings, number: 0),
         Choice(title: S.of(context).imageSettings, number: 1),
         Choice(title: S.of(context).desireListSettings, number: 2),
      ];
      selectedChoice = choices[0];
      isInitState = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    setData(context);
    setText(context);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurple,
        title: new Text(title),
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
      drawer: drawerwidget.getDrawerWidget(this, context, userdata.userName, logOutMsg), //侧边栏按钮Drawer
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
                              getBgImageWidget(0),
                            ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child:
                        Row(
                          mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(S.of(context).indexTitleMsg, style: TextStyle(
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
                                      isYearButton = S.of(context).indexYear;
                                      isYear= true;
                                      int allDay = int.parse(difference);
                                      double dbYear = allDay/365 ;
                                      int overDay = allDay - (dbYear.toInt()*365);
                                      String overYear = dbYear.toInt().toString() +S.of(context).indexYear+overDay.toString()+S.of(context).indexDay2;
                                      setLifeDay(overYear);
                                    }
                                    else{
                                      isYearButton = S.of(context).indexDay;
                                      isYear= false;
                                      setLifeDay(difference+S.of(context).indexDay2);
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
                            toastclass.showToast(S.of(context).toastNoLogin);
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
                        subtitle: new Text(S.of(context).pastAimsDay+pastDataList[index].itemMonth.toString()+S.of(context).indexMonth+pastDataList[index].itemDay.toString()+","+pastDataList[index].itemYear.toString()+weeknameclass.getWeekName(pastDataList[index].itemWeekDay-1), style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text(S.of(context).pastTooMsg+checkDay(0, pastDataList[index])+S.of(context).indexDay2, style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            )), new Icon(Icons.chevron_right)]),

                        onLongPress:(){
                          String toastMsg = "";
                          int allDay = int.parse(checkDay(0, pastDataList[index]));
                          if(allDay>=365){
                            double dbYear = allDay/365 ;
                            int overDay = allDay - (dbYear.toInt()*365);
                            toastMsg = S.of(context).toastMsgError+dbYear.toInt().toString() +S.of(context).indexYear+overDay.toString()+S.of(context).indexDay2;
                          }
                          else{
                            toastMsg = S.of(context).toastYearError;
                          }
                          toastclass.showToast(toastMsg);
                        },
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
                            toastclass.showToast(S.of(context).toastNoLogin);
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
                        subtitle: new Text(S.of(context).pastAimsDay+futureDataList[index].itemMonth.toString()+S.of(context).indexMonth+futureDataList[index].itemDay.toString()+","+futureDataList[index].itemYear.toString()+weeknameclass.getWeekName(futureDataList[index].itemWeekDay-1), style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text(S.of(context).futureTooMsg+checkDay(1, futureDataList[index])+S.of(context).indexDay2, style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            )), new Icon(Icons.chevron_right)]),
                        onLongPress:(){
                          String toastMsg = "";
                          int allDay = int.parse(checkDay(1, futureDataList[index]));
                          if(allDay>=365){
                            double dbYear = allDay/365 ;
                            int overDay = allDay - (dbYear.toInt()*365);
                            toastMsg = S.of(context).toastMsgError2+dbYear.toInt().toString() +S.of(context).indexYear+overDay.toString()+S.of(context).indexDay2;
                          }
                          else{
                            toastMsg = S.of(context).toastYearError;
                          }
                          toastclass.showToast(toastMsg);
                        },
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
    isInitState = true;
    if(userdata.imageBg != null){
      userBgImageBytes = base64Decode(userdata.imageBg);
    }
    if(userdata.imageFace != null){
      userImageBytes = base64Decode(userdata.imageFace);
    }

    getDesireList();
    super.initState();
  }


}


