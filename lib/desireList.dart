import 'package:cactime/util/desire.dart';
import 'package:flutter/material.dart';
import 'package:cactime/model//userdata.dart' as userdata;

class DesireListActivity extends StatefulWidget {
 List<String> cities =  userdata.allDesireList;
 ValueChanged<List<String>> onSelectedCitiesListChanged;
 List<String> _tempSelectedCities = [];

  @override
  desireList createState() => desireList();
}

class desireList extends State<DesireListActivity> {
  var desireAddEdit = TextEditingController(text: "");


  //重新整理夢想列表
  void desireReset(){
    setState(() {
      widget.cities =  userdata.allDesireList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("願望設定"),
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
                  itemCount: widget.cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = widget.cities[index];
                    return Container(
                      child: CheckboxListTile(
                          title: Text(
                            cityName,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          value: widget._tempSelectedCities.contains(cityName),
                          onChanged: (bool value) {
                            if (value) {
                              if (!widget._tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  widget._tempSelectedCities.add(cityName);
                                });
                              }
                            } else {
                              if (widget._tempSelectedCities.contains(cityName)) {
                                setState(() {
                                  widget._tempSelectedCities.removeWhere(
                                          (String city) => city == cityName);
                                });
                              }
                            }
                            widget
                                .onSelectedCitiesListChanged(widget._tempSelectedCities);
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
                          for(int i=0; i<widget._tempSelectedCities.length; i++){
                            desire item = new desire();
                            item.desireName = widget._tempSelectedCities[i];
                            item.isCheck = false;
                            DesireList.add(item);
                            if(msg.length == 0){
                              msg = widget._tempSelectedCities[i];
                            }
                            else{
                              msg = msg+ ","+widget._tempSelectedCities[i];
                            }
                          }

                          userdata.DesireList = DesireList;

                          Navigator.pop(context, msg);
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          '完成',
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
        title: new Text("新增願望"),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                controller: desireAddEdit,
                autofocus: true,
                decoration: new InputDecoration(hintText: '請輸入您的願望'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('確定'),
              onPressed: () {
                userdata.allDesireList.add(desireAddEdit.text);
                desireReset();
//                callapiclass.getLogin(passwordEdit.text, type, context);
                Navigator.pop(context);
              })
        ],
      ),
    )) {
    }
  }

  @override
  void initState() {
    widget._tempSelectedCities = new List<String>();
    if(userdata.DesireList != null){
      for(int i=0; i<userdata.DesireList.length; i++){
        widget._tempSelectedCities.add(userdata.DesireList[i].desireName);
      }
    }
    super.initState();
  }

}

