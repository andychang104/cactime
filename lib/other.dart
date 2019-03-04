import 'dart:ui';
import 'package:flutter/material.dart';

class Other extends StatefulWidget {
  @override
  other createState() => other();
}

class other extends State<Other> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
            backgroundColor: Colors.deepPurple,
            title: new Text("關於"),
            actions: <Widget>[]),
        body:

        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
          child:     Stack(
              alignment: FractionalOffset.bottomCenter,
              children: [

                Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 100.0, left: 10.0, right: 10.0, bottom: 10.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: <Widget>[
                                    Image.asset('images/ic_launcher_140.png', width:100.0, height: 100.0, fit: BoxFit.cover),
                                    Text("人生倒數計時器",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          height:1.2,
                                          color: const Color(0xFF333333),
                                        )),
                                    Text("版本號碼：1.2.0",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          height:1.2,
                                          color: Colors.black54,
                                        )),
                                  ]))])),

                new Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text("© 2019 人生倒數計時器團隊 版權所有 侵害必究",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                      )),
                                ],
                              ))
                        ]))

              ]),



        )




    );
  }


}
