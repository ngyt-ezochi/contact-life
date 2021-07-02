import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainModel extends ChangeNotifier {
  DateFormat outputFormat = DateFormat('MM月dd日');
  DateTime today = DateTime.now();

  //開始日
  String startDateText = '07月01日';
  //残りの日数
  int todayCounter = 14;
  //期間のゲージのパーセンテージ
  double percentage = 0.7;

  //レンズの在庫数
  int lensStock = 6;

  //洗浄液の在庫数
  int washerStock = 6;

  //通知機能のオンオフ
  bool isPushedOn = false;
  String pushTime = '18:00';

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

  //通知のオンオフを切り替える
  void changeSwitch() {
    isPushedOn = !isPushedOn;
    notifyListeners();
  }

  //期間のスライドバー切り替え
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

  //通知日のスライドバー切り替え
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

  // 開始日について
  void selectStartDate(DateTime selectedStartDate) {
    this.startDateText = outputFormat.format(selectedStartDate);
    notifyListeners();
  }

  //レンズについて
  void incrementStock(int num) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    lensStock += num;
    // lensStock = (prefs.getInt('lensStock') ?? 0) + num;
    // await prefs.setInt('stock', lensStock);
    notifyListeners();
  }

  void decrementStock() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (lensStock > 0) lensStock = (prefs.getInt('stock') ?? 0) - 1;
    if (lensStock > 0) lensStock = lensStock - 1;
    // await prefs.setInt('stock', lensStock);
    notifyListeners();
  }

  //洗浄液について
  void incrementWasher(int num) async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // washerStock = (prefs.getInt('washer') ?? 0) + num;
    washerStock = washerStock + num;
    // await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void decrementWasher() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (washerStock > 0) washerStock = (prefs.getInt('washer') ?? 0) - 1;
    if (washerStock > 0) washerStock = washerStock - 1;
    // await prefs.setInt('washer', washerStock);
    notifyListeners();
  }

  void selectPushTime(TimeOfDay t) async {
    var now = DateTime.now();
    var dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    this.pushTime = (DateFormat.Hm()).format(dt);
    notifyListeners();
  }
}
