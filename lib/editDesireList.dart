import 'package:cactime/desireList.dart';
import 'package:cactime/util/desire.dart';
import 'package:cactime/util/desireItemWidget.dart';
import 'package:flutter/material.dart';
import 'package:cactime/model//userdata.dart' as userdata;

List<desire> DesireList;

class EidtDesireListActivity extends StatefulWidget {
  List<String> dialogList = ["修改", "刪除", "已完成願望"];
  ValueChanged<List<String>> onSelectedCitiesListChanged;
  desireItemWidget desireItemWidgetClass = new desireItemWidget();

  @override
  editDesireList createState() => editDesireList();
}

class editDesireList extends State<EidtDesireListActivity> {
  var desireAddEdit = TextEditingController(text: "");

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
                DesireList = userdata.DesireList;
                Navigator.push<String>(context, new MaterialPageRoute(builder: (BuildContext context){
                  return new DesireListActivity();
                })).then((String result){
                  if(result != null){
                    //widget.setDesirelist(result);
                    upData("加入願望");
                  }
                });
                //showDesireDialog();
              },
            )
          ]
      ),
      body: new Container(
        child: Column(
          children: <Widget>[

            Padding(
                padding:
                const EdgeInsets.all(10),
                child: Text("您在人生最後的日子有一定想要完成的願望嗎？\n列出您的願望，在未來日子裡好好審視完成了幾件", textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 16.0,
                  color:
                  const Color(0xFF8f8f8f),
                )))
            ,
            Padding(
                padding:
                const EdgeInsets.all(0),
                child: new Container(
                  height: 1.0,
                  color: const Color(0xFFe3e3e3),
                )),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height:0,
                  ),
                  itemCount: userdata.DesireList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = userdata.DesireList[index].desireName;
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      dense: false,
                      leading: null,
                      //左侧首字母图标显示，不显示则传null
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                ),
                                new Expanded(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(userdata.DesireList[index].desireName,
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color:
                                            const Color(0xFF333333),
                                          )),

//                                      Padding(
//                                        padding: const EdgeInsets.only(top:5.0),
//                                      ),

                                    ],
                                  ),
                                ),

                                widget.desireItemWidgetClass.getdesireItemWidget(userdata.DesireList[index].isCheck),

                                Padding(
                                  padding: const EdgeInsets.only(right:10.0),
                                )


                              ],
                            ),

                          ]
                      )

                      ,
                      //子item的标题
                      onTap: () {

                        department(index);
//                        Navigator.push(
//                          context,
//                          MaterialPageRoute(builder: (context) => Video(giverList[index].video_url)),
//                        );
                      },
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
                          Navigator.pop(context, "");
                        },
                        color: Colors.deepPurple,
                        child: Text(
                          '送出',
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

  //動作選擇dialog
  Future<Null> department(int setNunBer) async {
    if(userdata.DesireList[setNunBer].isCheck){
      widget.dialogList = ["修改", "刪除", "未完成願望"];
    }
    else{
      widget.dialogList = ["修改", "刪除", "已完成願望"];
    }
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("設定"),
          children: widget.dialogList.map((value) {
            return new SimpleDialogOption(
                onPressed: () {
                  if (value == "修改") {
                    Navigator.pop(context);
                    showEditDesireDialog(setNunBer);
                  } else if(value == "刪除") {
                    userdata.DesireList.removeAt(setNunBer);
                    upData("刪除");
                    Navigator.pop(context);
                  } else {
                    if(userdata.DesireList[setNunBer].isCheck){
                      userdata.DesireList[setNunBer].isCheck = false;
                    }
                    else{
                      userdata.DesireList[setNunBer].isCheck = true;
                    }
                    upData("狀態變更");
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(value,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      )),
                ));
          }).toList(),

        ))) {
    }
  }

  //顯示修改願望視窗
  Future<Null> showEditDesireDialog(int setNunBer) async {
    desireAddEdit = TextEditingController(text:  userdata.DesireList[setNunBer].desireName);
    switch (await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: new Text("修改願望"),
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
                userdata.DesireList[setNunBer].desireName = desireAddEdit.text;
                upData("修改");
                Navigator.pop(context);
              })
        ],
      ),
    )) {
    }
  }

  void upData(String type){
    setState(() {
      if(type == "加入願望"){
        for(int i=0; i<DesireList.length; i++){
          for(int j=0; j<userdata.DesireList.length; j++){
            if(userdata.DesireList[j].desireName == DesireList[i].desireName){
              userdata.DesireList[j].isCheck = DesireList[i].isCheck;
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

}

