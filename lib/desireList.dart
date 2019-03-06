import 'package:cactime/generated/i18n.dart';
import 'package:cactime/util/desire.dart';
import 'package:flutter/material.dart';
import 'package:cactime/model//userdata.dart' as userdata;

List<String> _tempSelectedCities = [];
List<String> cities =  userdata.allDesireList;
ValueChanged<List<String>> onSelectedCitiesListChanged;

class DesireListActivity extends StatefulWidget {


  @override
  desireList createState() => desireList();
}

class desireList extends State<DesireListActivity> {
  var desireAddEdit = TextEditingController(text: "");


  //重新整理夢想列表
  void desireReset(){
    setState(() {
      cities =  userdata.allDesireList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(S.of(context).desirelistTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.white,
              onPressed: () {
                showDesireDialog();
              },
            )
            ]
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height:0,
                  ),
                  itemCount: cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = cities[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            cityName,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: _tempSelectedCities.contains(cityName),
                          onChanged: (bool value) {
                            if (value) {
                              if (!_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  _tempSelectedCities.add(cityName);
                                });
                              }
                            } else {
                              if (_tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  _tempSelectedCities.removeWhere(
                                          (String city) => city == cityName);
                                });
                              }
                            }

                            onSelectedCitiesListChanged(_tempSelectedCities);
                          }),
                    );
                  }),
            ),

            Padding(
              padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 5.0),
              child:           Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: MaterialButton(
                        height: 45.0,
                        onPressed: () {

                          String msg = "";
                          List<desire> DesireList = new  List<desire>();
                          for(int i=0; i<_tempSelectedCities.length; i++){
                            desire item = new desire();
                            item.desireName = _tempSelectedCities[i];
                            item.isCheck = false;
                            DesireList.add(item);
                            if(msg.length == 0){
                              msg = _tempSelectedCities[i];
                            }
                            else{
                              msg = msg+ ","+_tempSelectedCities[i];
                            }
                          }

                          userdata.DesireList = DesireList;

                          Navigator.pop(context, msg);
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          S.of(context).newdayNewPutBtn,
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
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


  //顯示輸入願望視窗
  Future<Null> showDesireDialog() async {
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text(S.of(context).desirelistNewTitle),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                controller: desireAddEdit,
                autofocus: true,
                decoration: new InputDecoration(hintText: S.of(context).desirelistHint),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: Text(S.of(context).dialogNoBtn),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: Text(S.of(context).dialogOkBtn),
              onPressed: () {
                userdata.allDesireList.add(desireAddEdit.text);
                desireReset();
                Navigator.pop(context);
              })
        ],
      ),
    )) {
    }
  }

  @override
  void initState() {
    _tempSelectedCities = new List<String>();
    if(userdata.DesireList != null){
      for(int i=0; i<userdata.DesireList.length; i++){
        _tempSelectedCities.add(userdata.DesireList[i].desireName);
      }
    }
    super.initState();
  }

}

