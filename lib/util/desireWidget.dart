import 'package:cactime/generated/i18n.dart';
import 'package:cactime/index.dart';
import 'package:cactime/mainIndex.dart';
import 'package:cactime/other.dart';
import 'package:cactime/personal.dart';
import 'package:cactime/splashScreen.dart';
import 'package:cactime/util/preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share/share.dart';
import 'package:cactime/model//userdata.dart' as userdata;


preferences preferencesclass = new preferences();

class drawerWidget {
  Drawer getDrawerWidget(MainIndex activity, BuildContext context, String userName, String logOutMsg) {
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

                                child: Stack(
                                  alignment: FractionalOffset.bottomRight,
                                  children: [            new Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        activity.getImage(1);
                                      },
                                      child:  activity.getBgImageWidget(1),
                                    ),
                                    width: 55.0,
                                    height: 55.0,
                                  )
                                  ,
                                  new Container(
                                    color: Colors.white,
                                    child: GestureDetector(
                                      onTap: () {
                                        activity.getImage(1);
                                      },
                                      child:  Icon(Icons.image, size: 15.0),
                                    ),
                                    width: 15.0,
                                    height: 15.0,
                                  )
                                  ,]),
                             ),
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
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Personal()),);
            },
            padding:
                EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                Icon(Icons.announcement),
                Padding(padding: const EdgeInsets.only(left: 10.0)),
                new Text(S.of(context).privacyTitle,
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
            onPressed: () {
              if(userdata.uid == "nologin84598349"){
                toastclass.showToast(S.of(context).dialogNoLoginMain);
              }
              else{
                Navigator.of(context).pop();
                activity.editDesire();
              }
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
                      Icon(Icons.edit),
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      new Text(S.of(context).desireListSettings,
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
                new Text(S.of(context).shareTitle,
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
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Other()),);
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
                      Icon(Icons.clear_all),
                      Padding(padding: const EdgeInsets.only(left: 10.0)),
                      new Text(S.of(context).aboutTitle,
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
