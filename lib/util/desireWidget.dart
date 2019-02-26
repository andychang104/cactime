import 'package:cactime/index.dart';
import 'package:cactime/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';

class drawerWidget {
  Drawer getDrawerWidget(BuildContext context, String userName, String logOutMsg) {
    Drawer drawerWidget;
    drawerWidget = new Drawer(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                alignment: FractionalOffset.bottomLeft,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.asset(
                            'images/bg_account_pattern.png',
                            height: 150.0, fit: BoxFit.cover),
                      ]),
                  new Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      child: new CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'images/ic_launcher_140.png')),
                                      width: 48.0,
                                      height: 48.0,
                                    )
                                  ],
                                )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(userName,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        )),
                                  ],
                                ))
                          ])),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 10.0)),
            ],
          ),
          FlatButton(
            onPressed: () => {},
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                Icon(Icons.announcement),
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                new Text("個資宣告",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: const Color(0xFF333333),
                    )),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Container(
                height: 1,
                color: const Color(0xFFf0f0f0),
              )),
          FlatButton(
            onPressed: () => {},
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[

                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      Icon(Icons.edit),
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      new Text("編輯願望",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color(0xFF333333),
                          )),
                    ],
                  ),
                ]),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Container(
                height: 1,
                color: const Color(0xFFf0f0f0),
              )),
          FlatButton(
            onPressed: ()  {
              Share.share('https://play.google.com/store/apps/details?id=cactime.com.cactime');
              Navigator.of(context).pop(); // close the drawer
            },
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                Icon(Icons.share),
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                new Text("分享",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: const Color(0xFF333333),
                    )),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Container(
                height: 1,
                color: const Color(0xFFf0f0f0),
              )),
          FlatButton(
            onPressed: () => {},
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      Icon(Icons.clear_all),
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      new Text("關於",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color(0xFF333333),
                          )),
                    ],
                  ),
                ]),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Container(
                height: 1,
                color: const Color(0xFFf0f0f0),
              )),
          FlatButton(
            onPressed: () {
              preferencesclass.delData("uid");
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new Splash()), (route) => route == null);
            },
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 10.0, bottom: 5.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      Icon(Icons.arrow_forward),
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      new Text(logOutMsg,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: const Color(0xFF333333),
                          )),
                    ],
                  ),
                ]),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Container(
                height: 1,
                color: const Color(0xFFf0f0f0),
              ))
        ])));

    return drawerWidget;
  }
}
