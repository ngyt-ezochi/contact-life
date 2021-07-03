import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class MainModel extends ChangeNotifier {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  DateFormat outputFormat = DateFormat('MM月dd日');
  DateTime today = DateTime.now();
  //期間のゲージのパーセンテージ
  double percentage = 0.7;

  //開始日
  DateTime startDate = DateTime.now();
  String startDateText = '07月01日';
  //終了日
  DateTime goalDate = DateTime.now().add(Duration(days: 13));
  String goalDateText = '07月14日';

  late int startTimeStamp = DateTime.now().millisecondsSinceEpoch;
  late int goalTimeStamp =
      DateTime.now().add(Duration(days: 13)).millisecondsSinceEpoch;

  //残りの日数
  int todayCounter = 14;
  //使用期限
  int daysCounter = 14;
  //文字として、仮置き
  String putTodayCounter = '14';

  //レンズの在庫数
  int lensStock = 6;
  //文字として、仮置き
  String putLensStock = '6';

  //洗浄液の在庫数
  int washerStock = 6;
  //文字として、仮置き
  String putWasherStock = '6';

  //通知機能のオンオフ
  bool isPushedOn = false;
  String pushTime = '18:00';

  //期間のスライドバーの設定
  int daysGroupValue = 0;
  final Map<int, Widget> maxDays = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months"),
  };

  //通知日のスライドバーの設定
  int pushDateGroupValue = 0;
  final Map<int, Widget> pushDateSet = const <int, Widget>{
    0: Text("前日"),
    1: Text("最終日"),
  };

  //以下変数の取得
  void getDaysCounterAndPercentage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysCounter = prefs.getInt('daysCounter') ?? daysCounter;
    startTimeStamp = prefs.getInt('startTimeStamp') ?? startTimeStamp;
    this.startDate = DateTime.fromMillisecondsSinceEpoch(startTimeStamp);
    goalTimeStamp = prefs.getInt('goalTimeStamp') ?? goalTimeStamp;
    this.goalDate = DateTime.fromMillisecondsSinceEpoch(goalTimeStamp);
    this.startDate = DateTime(startDate.year, startDate.month, startDate.day);
    this.goalDate = DateTime(goalDate.year, goalDate.month, goalDate.day);
    this.today = DateTime(today.year, today.month, today.day);
    this.todayCounter = (goalDate.difference(today).inDays + 1);
    this.percentage = todayCounter / daysCounter;
    prefs.setDouble('percentage', percentage);
    notifyListeners();
  }

  //開始日と終了日の取得
  void getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDateText = prefs.getString('startDateText') ?? startDateText;
    this.goalDateText = prefs.getString('goalDateText') ?? goalDateText;
  }

  //使用期限の取得
  void getDaysCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysCounter = prefs.getInt('daysCounter') ?? daysCounter;
    this.daysGroupValue = prefs.getInt('daysGroupValue') ?? daysGroupValue;
    notifyListeners();
  }

  //レンズ数の在庫
  void getLensStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.lensStock = prefs.getInt('lensStock') ?? lensStock;
    notifyListeners();
  }

  //洗浄液数の在庫
  void getWasherStock() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.washerStock = prefs.getInt('washerStock') ?? washerStock;
    notifyListeners();
  }

  void getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.isPushedOn = prefs.getBool('isPushedOn') ?? isPushedOn;
    this.pushDateGroupValue =
        prefs.getInt('pushDateGroupValue') ?? pushDateGroupValue;
    notifyListeners();
  }

  //以下変数の変更
  //通知のオンオフを切り替える
  void changeSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPushedOn = !isPushedOn;
    prefs.setBool('isPushedOn', isPushedOn);
    notifyListeners();
  }

  //共有関数：開始日と終了日をTimeStampに代入
  void setTimeStampFromDate(
      SharedPreferences prefs, DateTime startDate, DateTime goalDate) async {
    startTimeStamp = startDate.millisecondsSinceEpoch;
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('startTimeStamp', startTimeStamp);
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
  }

  //goalのTimeStampに代入
  void setTimeStampFromGoalDate(
      SharedPreferences prefs, DateTime goalDate) async {
    goalTimeStamp = goalDate.millisecondsSinceEpoch;
    await prefs.setInt('goalTimeStamp', goalTimeStamp);
  }

  //期間のスライドバー切り替え
  void slidingDaysControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysGroupValue = changeFormGroupValue;
    switch (daysGroupValue) {
      case 0:
        setDaysCounter(14);
        await prefs.setInt('daysGroupValue', 0);
        break;
      case 1:
        setDaysCounter(30);
        await prefs.setInt('daysGroupValue', 1);
        break;
      case 2:
        setDaysCounter(90);
        await prefs.setInt('daysGroupValue', 2);
        break;
    }
    this.daysCounter = prefs.getInt('daysCounter') ?? daysCounter;
    notifyListeners();
  }

  //期間と終了日の設定
  void setDaysCounter(daysCounter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysCounter = daysCounter;
    await prefs.setInt('daysCounter', daysCounter);
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    print(goalDate);
    setTimeStampFromGoalDate(prefs, goalDate);
    this.goalDateText = outputFormat.format(goalDate);
    await prefs.setString('goalDateText', goalDateText);
    // if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  //通知日のスライドバー切り替え
  void slidingPushDateControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.pushDateGroupValue = changeFormGroupValue;
    switch (pushDateGroupValue) {
      case 0:
        await prefs.setInt('pushDateGroupValue', 0);
        break;
      case 1:
        await prefs.setInt('pushDateGroupValue', 1);
        break;
    }
    // resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  // 開始日について
  void selectStartDate(DateTime selectedStartDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDate = selectedStartDate;
    print(startDate);
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    print(goalDate);
    this.startDateText = outputFormat.format(startDate);
    this.goalDateText = outputFormat.format(goalDate);
    setTimeStampFromDate(prefs, startDate, goalDate);
    await prefs.setString('startDateText', startDateText);
    await prefs.setString('goalDateText', goalDateText);
    notifyListeners();
  }

  //使用期限の増減
  void incrementDaysCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    daysCounter = (prefs.getInt('daysCounter') ?? daysCounter) + 1;
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    setTimeStampFromGoalDate(prefs, goalDate);
    this.goalDateText = outputFormat.format(goalDate);
    await prefs.setInt('daysCounter', daysCounter);
    await prefs.setString('goalDateText', goalDateText);
    // if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  void decrementDaysCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (daysCounter > 1)
      daysCounter = (prefs.getInt('daysCounter') ?? daysCounter) - 1;
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    setTimeStampFromGoalDate(prefs, goalDate);
    this.goalDateText = outputFormat.format(goalDate);
    await prefs.setString('goalDateText', goalDateText);
    await prefs.setInt('daysCounter', daysCounter);
    // if (pushOn) resetNotification(goalDate, pushHour, pushMin);
    notifyListeners();
  }

  //レンズについて
  void incrementLensStock(int num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // lensStock += num;
    lensStock = (prefs.getInt('lensStock') ?? lensStock) + num;
    await prefs.setInt('lensStock', lensStock);
    notifyListeners();
  }

  void decrementLensStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lensStock > 0) lensStock = (prefs.getInt('lensStock') ?? lensStock) - 1;
    // if (lensStock > 0) lensStock = lensStock - 1;
    await prefs.setInt('lensStock', lensStock);
    notifyListeners();
  }

  void decrementLensStockAndResetStartDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lensStock > 0) lensStock = (prefs.getInt('lensStock') ?? lensStock) - 1;
    await prefs.setInt('lensStock', lensStock);
    selectStartDate(today);
    notifyListeners();
  }

  //洗浄液について
  void incrementWasherStock(int num) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    washerStock = (prefs.getInt('washerStock') ?? washerStock) + num;
    // washerStock = washerStock + num;
    await prefs.setInt('washerStock', washerStock);
    notifyListeners();
  }

  void decrementWasherStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (washerStock > 0)
      washerStock = (prefs.getInt('washerStock') ?? washerStock) - 1;
    await prefs.setInt('washerStock', washerStock);
    notifyListeners();
  }

  void selectPushTime(TimeOfDay t) async {
    var now = DateTime.now();
    var dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    this.pushTime = (DateFormat.Hm()).format(dt);
    notifyListeners();
  }

  //textFieldで数を入力
  void inputDaysCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysCounter = int.parse(putTodayCounter);
    await prefs.setInt('daysCounter', daysCounter);

    notifyListeners();
  }

  void inputLensStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.lensStock = int.parse(putLensStock);
    await prefs.setInt('lensStock', lensStock);
    notifyListeners();
  }

  void inputWasherStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.washerStock = int.parse(putWasherStock);
    await prefs.setInt('washerStock', washerStock);
    notifyListeners();
  }
}
