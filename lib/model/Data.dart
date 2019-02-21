
import 'package:cactime/model/Contact.dart';

class Data{
  List<Contact> contactList;

  Data({this.contactList});

  factory Data.fromJson(Map<String, dynamic> parsedJson){
    var recommendlist =  parsedJson as List;
    List<Contact> recommendList = recommendlist.map((i) => Contact.fromJson(i)).toList();

    return Data(
      contactList: recommendList,
    );
  }

}