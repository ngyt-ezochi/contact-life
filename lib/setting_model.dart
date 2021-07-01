import 'package:flutter/cupertino.dart';

class SettingModel extends ChangeNotifier {
  double percentage = 0.7;

  bool isPushedOn = false;

  //期間のスライドバーの設定
  int daysGroupValue = 0;
  final Map<int, Widget> maxDays = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months")
  };

  //通知日のスライドバーの設定
  int pushDateGroupValue = 0;
  final Map<int, Widget> pushDateSet = const <int, Widget>{
    0: Text("前日"),
    1: Text("最終日"),
  };

  void changeSwitch() {
    isPushedOn = !isPushedOn;
    notifyListeners();
  }

  void slidingDaysControl(changeFormGroupValue) async {
    this.daysGroupValue = changeFormGroupValue;
    // switch (daysGroupValue) {
    //   case 0:
    //     setLimitCounter(14);
    //     await prefs.setInt('limit', 0);
    //     break;
    //   case 1:
    //     setLimitCounter(30);
    //     await prefs.setInt('limit', 1);
    //     break;
    //   case 2:
    //     setLimitCounter(90);
    //     await prefs.setInt('limit', 2);
    //     break;
    // }
    // this.counter = prefs.getInt('counter');
    notifyListeners();
  }

  void slidingPushDateControl(changeFormGroupValue) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushDateGroupValue = changeFormGroupValue;
    // switch (pushDateGroupValue) {
    //   case 0:
    //     await prefs.setInt('pushDate', 0);
    //     break;
    //   case 1:
    //     await prefs.setInt('pushDate', 1);
    //     break;
    // }
    // resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }
}
