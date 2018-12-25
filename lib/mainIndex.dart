import 'package:cactime/editDay.dart';
import 'package:cactime/newDay.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

List<String> pastData = ["結婚紀念日","第一次認識"];
List<String> futureData = ["老婆生日","孩子生日","老媽生日","老爸生日"];

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

class mainIndex extends StatefulWidget {
  mainIndex(this.uid);

  final String title = "人生倒數計時器";
  final String uid;

  final List<Tab> myTabs = <Tab>[
    new Tab(text: '過去'),
    new Tab(text: '未來'),
  ];

  final drawerItems = [
    new DrawerItem("個資宣告", Icons.announcement),
    new DrawerItem("編輯願望", Icons.edit),
    new DrawerItem("分享", Icons.share),
    new DrawerItem("關於", Icons.clear_all),
    new DrawerItem("會員登入", Icons.arrow_forward)
  ];

  @override
  MainIndex createState() => MainIndex();
}

const List<Choice> choices = const <Choice>[
  const Choice(title: "編輯人生倒數"),
  const Choice(title: "編輯背景"),
  const Choice(title: "編輯願望"),
];
class MainIndex extends State<mainIndex> {



  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }


  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() {
      selectedDrawerIndex = index;

      if (selectedDrawerIndex == 2) {
        Share.share(
            'https://play.google.com/store/apps/details?id=cactime.com.cactime');
      }
    });
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == selectedDrawerIndex,
        onTap: () => onSelectItem(i),
      ));
    }

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

      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("張世明"),
              accountEmail: new Text("男"),
              currentAccountPicture: new CircleAvatar(
                  backgroundImage: AssetImage('images/ic_launcher_140.png')),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ), //侧边栏按钮Drawer
      body: new DefaultTabController(
        length: widget.myTabs.length,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: new Material(
                      color: Colors.black26,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(top: 40.0, bottom: 40.0),
                          child: new Text(
                            "50000天",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60.0,
                              color: Colors.black,
                            ),
                          )),
                    )),
              ],
            ),

            new Stack(
              children: <Widget>[
                new TabBar(
                  tabs: widget.myTabs,
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
                      child: new Icon(Icons.add),
                      onPressed: (){               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewDay(0)),
                      );}
                  ),
                  body: ListView.separated(
                    itemCount: pastData.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: false,
                        leading: null,//左侧首字母图标显示，不显示则传null
                        title: new Text(pastData[index], style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        )),//子item的标题
                        subtitle: new Text("目標日：12月 4,2018(週二)", style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text("過20天", style: TextStyle(
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
                      elevation: 0.0,
                      child: new Icon(Icons.add),
                      onPressed: (){               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewDay(1)),
                      );}
                  ), body: ListView.separated(
                    itemCount: futureData.length,
                    separatorBuilder: (BuildContext context, int index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        dense: false,
                        leading: null,//左侧首字母图标显示，不显示则传null
                        title: new Text(futureData[index], style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        )),//子item的标题
                        subtitle: new Text("目標日：12月 4,2018(週二)", style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        )),//子item的内容
                        trailing: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.end,
                            children: [new Text("剩21天", style: TextStyle(
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


}
