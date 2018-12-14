import 'package:cactime/index.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'generated/i18n.dart';
import 'package:cactime/util/preferences.dart';

preferences preferencesclass = new preferences();

class Splash extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    preferencesclass.getUserEmail();
    preferencesclass.getEmailCheck();

    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new Index(),
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

