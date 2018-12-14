import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class progressdialog {
  var progress = new ProgressHUD(
    backgroundColor: Colors.black12,
    text: "請稍候...",
    color: Colors.white,
    containerColor: Colors.black,
    borderRadius: 5.0,
  );
}