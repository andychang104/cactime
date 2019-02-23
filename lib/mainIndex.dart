import 'package:cactime/database/database_helper.dart';
import 'package:cactime/editDay.dart';
import 'package:cactime/editMainDay.dart';
import 'package:cactime/model/PastData.dart';
import 'package:cactime/newDay.dart';
import 'package:cactime/util/desireWidget.dart';
import 'package:cactime/util/notification.dart';
import 'package:cactime/util/weekname.dart';
import 'package:flutter/material.dart';
import 'package:cactime/util/toast.dart';
import 'package:cactime/model//userdata.dart' as userdata;


int indexType = 0;
int indexOneType = 0;
notification notificationclass = new notification();


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

  Choice selectedChoice = choices[0]; // The app's "state".

  //更多
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      selectedChoice = choice;
      if(selectedChoice.number == 0){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditMainDay()),
        );
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
    DateTime dbDay = new DateTime.utc(pastData.itemYear, pastData.itemMonth, pastData.itemDay);
    DateTime date2 = DateTime.now();
    String day = "";
    if(type == 0){
      day = date2.difference(dbDay).inDays.toString();
    }
    else{
      day = dbDay.difference(date2).inDays.toString();
    }
    return day;
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
      drawer: drawerwidget.getDrawerWidget(context, userdata.userName), //侧边栏按钮Drawer
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
                      alignment: FractionalOffset.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Image.asset(
                                  'images/bg_private.jpg',
                                  height: 170.0, fit: BoxFit.cover),
                            ]),
                        new Align(
                            alignment: FractionalOffset.center,
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
                        Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                          return new NewDay(0);
                        })).then((String result){
                          if(result != null){
                            indexType = 0;
                            setData(context);
                          }
                        });
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditDay(0)),
                          );
                        },
                      );
                    },
                  )),
                  Scaffold(floatingActionButton: new FloatingActionButton(
                      backgroundColor: const Color(0xFFff7800),
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      onPressed: (){
                        Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                          return new NewDay(1);
                        })).then((String result){
                          if(result != null){
                            indexType = 0;
                            setData(context);
                          }
                        });
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditDay(1)),
                          );
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
    int deathYesr = 76;
    if(userdata.Sex == "男"){
      deathYesr = 76;
    }
    else if(userdata.Sex == "女"){
      deathYesr = 81;
    }

    int allDeathYesr = deathYesr + userdata.mYear;

    DateTime selectedDate = new DateTime.utc(allDeathYesr, userdata.mMonth, userdata.mDay);
    DateTime date = DateTime.now();
    
    String difference = selectedDate.difference(date).inDays.toString();


    if(selectedDate.difference(date).inDays <=0){
      notificationclass.deleteNotification(49522011);
      difference = "0";
    }
    toastclass.showToast(difference);
    setLifeDay(difference+"天");
    super.initState();
  }

}


