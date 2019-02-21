import 'package:cactime/index.dart';
import 'package:cactime/mainIndex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cactime/model//userdata.dart' as userdata;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class checkUserType extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CheckUserType();
}

class CheckUserType extends State<checkUserType> {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      String uid = prefs.getString("uid");
      if(uid == null){
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new Index()
            ), (route) => route == null);
      }
      else{
        userdata.uid = uid;
        userdata.userName = prefs.getString("userName");
        userdata.Sex = prefs.getString("sex");
        userdata.mYear = prefs.getInt("mYear");
        userdata.mMonth = prefs.getInt("mMonth");
        userdata.mDay = prefs.getInt("mDay");
        userdata.isYear = prefs.getBool("isYear");
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => new mainIndex(uid)), (route) => route == null);
      }
    });

    super.initState();
  }


}

