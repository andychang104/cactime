import 'package:cactime/util/desire.dart';
import 'package:flutter/material.dart';
import 'package:cactime/model//userdata.dart' as userdata;

class EidtDesireListActivity extends StatefulWidget {
  List<String> cities =  [];
  List<bool> isCheck =  [];
  List<String> dialogList = ["修改", "刪除", "完成願望"];
  ValueChanged<List<String>> onSelectedCitiesListChanged;
  //List<String> _tempSelectedCities = [];

  @override
  editDesireList createState() => editDesireList();
}

class editDesireList extends State<EidtDesireListActivity> {
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
                  itemCount: widget.cities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cityName = widget.cities[index];
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
                                      Text(widget.cities[index],
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

                                Icon(Icons.chevron_right),

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

                        department();
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

                          String msg = "";
                          List<desire> DesireList = new  List<desire>();
                          for(int i=0; i<widget.cities.length; i++){
                            desire item = new desire();
                            item.desireName = widget.cities[i];
                            item.isCheck = false;
                            DesireList.add(item);
                            if(msg.length == 0){
                              msg = widget.cities[i];
                            }
                            else{
                              msg = msg+ ","+widget.cities[i];
                            }
                          }

                          userdata.DesireList = DesireList;

                          Navigator.pop(context, msg);
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
  Future<Null> department() async {
    switch (await showDialog(
        context: context,
        child: new SimpleDialog(
          title: new Text("設定"),
          children: widget.dialogList.map((value) {
            return new SimpleDialogOption(
                onPressed: () {
                  if (value == "CAC") {
                    Navigator.pop(context);
//                    askuser();
                  } else {
                    Navigator.pop(context);
//                    if (outeruserlist.length == 0) {
//                      toastclass.showToast("目前無借用者列表");
//                    } else {
//                      outeruser();
//                    }
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


  @override
  void initState() {
    widget.cities = new List<String>();
    if(userdata.DesireList != null){
      for(int i=0; i<userdata.DesireList.length; i++){
        widget.cities.add(userdata.DesireList[i].desireName);
        widget.isCheck.add(userdata.DesireList[i].isCheck);
      }
    }
    super.initState();
  }

}

