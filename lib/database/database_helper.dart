import 'dart:async';
import 'dart:io' as io;
import 'package:cactime/mainIndex.dart';
import 'package:cactime/model/PastData.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;


  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    //String tableName = mainapp.tableName;
    await db.execute(
        "CREATE TABLE pastData (id TEXT PRIMARY KEY, itemName TEXT, itemYear INTEGER, itemMonth INTEGER, itemDay INTEGER, itemIsTop TEXT, itemIsPush TEXT, itemAllDay TEXT, itemWeekDay INTEGER)");
    await db.execute(
        "CREATE TABLE futureData (id TEXT PRIMARY KEY, itemName TEXT, itemYear INTEGER, itemMonth INTEGER, itemDay INTEGER, itemIsTop TEXT, itemIsPush TEXT, itemAllDay TEXT, itemWeekDay INTEGER)");
  }

  Future<int> savePastData(PastData pastData, String tableName) async {
    var dbClient = await db;
    int res = await dbClient.insert(tableName, pastData.toMap());
    return res;
  }


  Future<List<PastData>> getPastData(MainIndex mainindex, BuildContext context) async {
    var dbClient = await db;
    List<Map> pastDatalist = await dbClient.rawQuery('SELECT * FROM pastData');
    List<PastData> employees1 = new List();
    for (int i = 0; i < pastDatalist.length; i++) {
      var pastData = new PastData(pastDatalist[i]["itemName"], pastDatalist[i]["itemYear"], pastDatalist[i]["itemMonth"], pastDatalist[i]["itemDay"], pastDatalist[i]["itemIsTop"],  pastDatalist[i]["itemIsPush"], pastDatalist[i]["itemAllDay"], pastDatalist[i]["itemWeekDay"], pastDatalist[i]["id"]);

      if(pastData.itemIsTop.indexOf("true") != -1){
        employees1.insert(0,pastData);
      }
      else{
        employees1.add(pastData);
      }
    }
    mainindex.pastDataList = employees1;
    print("GC"+employees1.length.toString());

    List<Map> futureDatalist = await dbClient.rawQuery("SELECT * FROM futureData");
    List<PastData> employees2 = new List();
    for (int i = 0; i < futureDatalist.length; i++) {
      var pastData = new PastData(futureDatalist[i]["itemName"], futureDatalist[i]["itemYear"], futureDatalist[i]["itemMonth"], futureDatalist[i]["itemDay"], futureDatalist[i]["itemIsTop"],  futureDatalist[i]["itemIsPush"], futureDatalist[i]["itemAllDay"], futureDatalist[i]["itemWeekDay"], futureDatalist[i]["id"]);

      if(pastData.itemIsTop.indexOf("true") != -1){
        employees2.insert(0,pastData);
      }
      else{
        employees2.add(pastData);
      }

    }

    mainindex.futureDataList = employees2;
    mainindex.setData(context);
    print("GC"+employees2.length.toString());
    //return employees;
  }


  Future<int> deletePastData(PastData pastData, String tableName) async {
    var dbClient = await db;

    int res =
    await dbClient.rawDelete('DELETE FROM $tableName WHERE id = ?', [pastData.id]);
    return res;
  }

  Future<bool> update(PastData pastData, String tableName) async {
    var dbClient = await db;
    int res =   await dbClient.update(tableName, pastData.toMap(),
        where: "id = ?", whereArgs: <String>[pastData.id]);
    return res > 0 ? true : false;
  }
}

