import 'package:flutter/material.dart';


class mainIndex extends StatefulWidget {
  mainIndex(this.uid);

  final String title = "人生倒數計時器";
  final String uid;

  @override
  MainIndex createState() => MainIndex();
}

class MainIndex extends State<mainIndex> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title), backgroundColor: Colors.deepPurple,),  //头部的标题AppBar
      drawer: new Drawer(     //侧边栏按钮Drawer
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(   //Material内置控件
              accountName: new Text('CYC'), //用户名
              accountEmail: new Text('example@126.com'),  //用户邮箱
              currentAccountPicture: new GestureDetector( //用户头像
                onTap: () => print('current user'),
                child: new CircleAvatar(    //圆形图标控件
                  backgroundImage: new NetworkImage('https://upload.jianshu.io/users/upload_avatars/7700793/dbcf94ba-9e63-4fcf-aa77-361644dd5a87?imageMogr2/auto-orient/strip|imageView2/1/w/240/h/240'),//图片调取自网络
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
                //用一个BoxDecoration装饰器提供背景图片
//                image: new DecorationImage(
//                  fit: BoxFit.fill,
//                  // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
//                  //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
//                  //image: new ExactAssetImage('images/ic_launcher_140.png'),
//                ),
              ),
            ),
            new ListTile(   //第一个功能项
                title: new Text('First Page'),
                trailing: new Icon(Icons.arrow_upward),
                onTap: () {
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SidebarPage()));
                }
            ),
            new ListTile(   //第二个功能项
                title: new Text('Second Page'),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new SidebarPage()));
                }
            ),
            new ListTile(   //第二个功能项
                title: new Text('Second Page'),
                trailing: new Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/a');
                }
            ),
            new Divider(),    //分割线控件
            new ListTile(   //退出按钮
              title: new Text('Close'),
              trailing: new Icon(Icons.cancel),
              onTap: () => Navigator.of(context).pop(),   //点击后收起侧边栏
            ),
          ],
        ),
      ),  //侧边栏按钮Drawer
      body: new Center(  //中央内容部分body
        child: new Text('HomePage',style: new TextStyle(fontSize: 35.0),),
      ),
    );
  }
}

