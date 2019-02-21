import 'package:cactime/checkUserType.dart';
import 'package:cactime/index.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'generated/i18n.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new checkUserType(),
        title: new Text(S.of(context).appSplashName,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.black26
          ),),
        image: new Image.asset('images/ic_launcher_140.png'),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        loaderColor: Colors.deepPurple
    );


  }
}

