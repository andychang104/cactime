import 'dart:ui';
import 'package:cactime/generated/i18n.dart';
import 'package:flutter/material.dart';

class Personal extends StatefulWidget {
  @override
  personal createState() => personal();
}

class personal extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
          backgroundColor: Colors.deepPurple,
          title: new Text(S.of(context).personalTitle),
          actions: <Widget>[]),
      body:

    Padding(
    padding: const EdgeInsets.only(
    top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
    child:       Card(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(
                      top: 5.0, left: 10.0, right: 10.0, bottom: 10.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Text(S.of(context).personalMsg,
                            style: TextStyle(
                              fontSize: 18.0,
                              height:1.2,
                              color: const Color(0xFF333333),
                            )),

                      ]))])),
    )




    );
  }


}
