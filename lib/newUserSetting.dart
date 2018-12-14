import 'package:flutter/material.dart';


class newUserSetting extends StatefulWidget {
  newUserSetting(this.uid, {Key key, this.title}) : super(key: key);
  final String title;
  final String uid;

  @override
  newUser createState() => newUser();
}

class newUser extends State<newUserSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.uid),
      ),
      body: new Container(
        margin: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0),
              child: Row(
                children: [
                  new Text(
                    "財產編號：",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: new TextField(
                        //controller: new TextEditingController(text: widget.msg1),
                        decoration: InputDecoration(
                          hintText: "請輸入財產編號",
                          border: new UnderlineInputBorder(),
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
              child: Row(
                children: [
                  new Text(
                    "使用者：",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: new TextField(
                          //controller: new TextEditingController(text: "$userName"),
                          decoration: InputDecoration(
                            border: new UnderlineInputBorder(),
                            hintText: "請輸入使用者名稱",
                          ),
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  new MaterialButton(
                    height: 50.0,
                    child: Text("選擇",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        )),
                    color: Colors.deepPurple,
                    elevation: 4.0,
                    textColor: Colors.white,
                    splashColor: Colors.black12,
                    onPressed: () {
                      //department();
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 20.0, right: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: new MaterialButton(
                      height: 50.0,
                      child: Text("送出",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          )),
                      color: Colors.deepPurple,
                      elevation: 4.0,
                      textColor: Colors.white,
                      splashColor: Colors.black12,
                      onPressed: () {
//                        String time = localdataclass.getTime();;
//                        callapiclass.getBorrow(userNmaeEdit.text, propertyEdit.text, time, outeruserlist, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

