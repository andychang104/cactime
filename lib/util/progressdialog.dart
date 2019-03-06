import 'package:cactime/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class progressdialog {

  Widget showProgress(BuildContext context){
    Widget progress = new ProgressHUD(
      backgroundColor: Colors.black12,
      text: S.of(context).progressMsg,
      color: Colors.white,
      containerColor: Colors.black,
      borderRadius: 5.0,
    );

    return progress;
  }

}