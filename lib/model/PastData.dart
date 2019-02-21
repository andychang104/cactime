class PastData {

  String id;
  String _itemName;
  int _itemYear;
  int _itemMonth;
  int _itemDay;
  String _itemIsTop;
  String _itemIsPush;
  String _itemAllDay;
  int _itemWeekDay;


  PastData(this._itemName, this._itemYear, this._itemMonth,  this._itemDay, this._itemIsTop, this._itemIsPush, this._itemAllDay, this._itemWeekDay);

  PastData.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._itemYear = obj["itemYear"];
    this._itemMonth = obj["itemMonth"];
    this._itemDay = obj["itemDay"];
    this._itemIsTop = obj["itemIsTop"];
    this._itemIsPush = obj["itemIsPush"];
    this._itemAllDay = obj["itemAllDay"];
    this._itemWeekDay = obj["itemWeekDay"];
  }

  String get itemName => _itemName;
  int get itemYear => _itemYear;
  int get itemMonth => _itemMonth;
  int get itemDay => _itemDay;
  String get itemIsTop => _itemIsTop;
  String get itemIsPush => _itemIsPush;
  String get itemAllDay => _itemAllDay;
  int get itemWeekDay => _itemWeekDay;


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["itemYear"] = _itemYear;
    map["itemMonth"] = _itemMonth;
    map["itemDay"] = _itemDay;
    map["itemIsTop"] = _itemIsTop;
    map["itemIsPush"] = _itemIsPush;
    map["itemAllDay"] = _itemAllDay;
    map["itemWeekDay"] = _itemWeekDay;
    return map;
  }
  void setUserId(String id) {
    this.id = id;
  }
}