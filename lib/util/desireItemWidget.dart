import 'package:flutter/material.dart';

class desireItemWidget {

  Widget getdesireItemWidget(bool isCheck){
    Widget desireItemWidget;

    if(!isCheck){
      desireItemWidget = Icon(Icons.chevron_right);
    }
    else{
      desireItemWidget = Icon(Icons.check);
    }
    return desireItemWidget;
  }

}