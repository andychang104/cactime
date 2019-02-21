class weekname {

  List<String> weekName = ["(週一)", "(週二)", "(週三)", "(週四)", "(週五)", "(週六)", "(週日)"];

  //取週
  String getWeekName(int index) {
    return weekName[index];
  }
}