import 'package:cactime/desireList.dart';
import 'package:cactime/newUserSetting.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class desireEditWidget {

  Widget getdesireEditWidget(newUser widget, BuildContext context,int type){
    Widget desireEditWidget;
    if(type == 0){
      desireEditWidget = Padding(
          padding: const EdgeInsets.all(0),
      );
    }
    else{
      desireEditWidget =
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, top: 20.0, right: 8.0),
            child: Row(
              mainAxisAlignment : MainAxisAlignment.start,
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                new Text(
                  "願望：",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.desireText = new RichText(
                      text: new TextSpan(
                          text: widget.desirelist,
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: widget.desireTextColor,
                          ),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                                return new DesireListActivity();
                              })).then((String result){
                                if(result != null){
                                  widget.setDesirelist(result);
                                }
                              });
                            }),
                    ),
                  ),
                ),
                new Icon(Icons.chevron_right),
              ],
            ),
          );
    }
    return desireEditWidget;
  }
}