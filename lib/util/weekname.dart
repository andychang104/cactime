import 'package:cactime/generated/i18n.dart';
import 'package:flutter/cupertino.dart';

class weekname {

  //取週
  String getWeekName(int index, BuildContext context) {
    List<String> weekName = [S.of(context).pastArray1, S.of(context).pastArray2, S.of(context).pastArray3, S.of(context).pastArray4, S.of(context).pastArray5, S.of(context).pastArray6, S.of(context).pastArray7];
    return weekName[index];
  }
}