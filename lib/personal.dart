import 'dart:ui';
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
          title: new Text("個資委託宣告"),
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
                        Text("本行動應用程式在獲得您同意之前提下，基於意見處理、消費者服務及行銷之目的，向您蒐集上述欄位之個人資料，並僅供人生倒數計時團隊就前述目的範圍及存續期間內，作合於我國相關法令且必要利用，除履行法定義務或經您同意之情形外，不再另作其他處理或利用。針對您所提供之個人資料，可按我國個人資料保護法第3條規定行使權利。倘若您未能提供欄位所需資料，本行動應用程式將無法適時或完整提供回覆或服務，而將會影響您之權益。",
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
