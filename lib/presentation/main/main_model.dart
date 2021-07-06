import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MainModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DateFormat outputFormat = DateFormat('MM月dd日');
  DateTime today = DateTime.now();
  //期間のゲージのパーセンテージ
  double percentage = 1.0;

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

  //通知の時間
  String noticeTime = '18:00';
  TimeOfDay noticeTimeOfDay = TimeOfDay(hour: 18, minute: 00);
  int noticeHour = 18;
  int noticeMin = 00;

  late DateTime noticeDate;
  late String noticeBody;

  //期間のスライドバーの設定
  int daysGroupValue = 0;
  final Map<int, Widget> maxDays = const <int, Widget>{
    0: Text("2Weeks"),
    1: Text("1Month"),
    2: Text("3Months"),
  };

  //通知日のスライドバーの設定
  int noticeDateGroupValue = 0;
  final Map<int, Widget> noticeDateSet = const <int, Widget>{
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
    if (todayCounter < 1) {
      this.todayCounter = 1;
    }
    this.percentage = todayCounter / daysCounter;
    prefs.setDouble('percentage', percentage);
    notifyListeners();
  }

  //開始日と終了日の取得
  void getDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDateText =
        prefs.getString('startDateText') ?? outputFormat.format(startDate);
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
    this.noticeDateGroupValue =
        prefs.getInt('pushDateGroupValue') ?? noticeDateGroupValue;
    this.noticeTime = prefs.getString('noticeTime') ?? noticeTime;
    this.noticeHour = prefs.getInt('noticeHour') ?? noticeHour;
    this.noticeMin = prefs.getInt('noticeMin') ?? noticeMin;
    notifyListeners();
  }

  //以下変数の変更
  //通知のオンオフを切り替える
  void changeSwitch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPushedOn = !isPushedOn;
    if (isPushedOn) {
      resetNotice(goalDate, noticeHour, noticeMin);
      print('通知します');
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
      print('キャンセル');
    }
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
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    this.goalDateText = outputFormat.format(goalDate);
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    setTimeStampFromGoalDate(prefs, goalDate);
    await prefs.setInt('daysCounter', daysCounter);
    await prefs.setString('goalDateText', goalDateText);
    notifyListeners();
  }

  //通知日のスライドバー切り替え
  void slidingPushDateControl(changeFormGroupValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.noticeDateGroupValue = changeFormGroupValue;
    switch (noticeDateGroupValue) {
      case 0:
        await prefs.setInt('pushDateGroupValue', 0);
        break;
      case 1:
        await prefs.setInt('pushDateGroupValue', 1);
        break;
    }
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    notifyListeners();
  }

  // 開始日について
  void selectStartDate(DateTime selectedStartDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.startDate = selectedStartDate;
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    this.startDateText = outputFormat.format(startDate);
    this.goalDateText = outputFormat.format(goalDate);
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
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
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    await prefs.setInt('daysCounter', daysCounter);
    await prefs.setString('goalDateText', goalDateText);
    notifyListeners();
  }

  void decrementDaysCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (daysCounter > 1)
      daysCounter = (prefs.getInt('daysCounter') ?? daysCounter) - 1;
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    setTimeStampFromGoalDate(prefs, goalDate);
    this.goalDateText = outputFormat.format(goalDate);
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    await prefs.setString('goalDateText', goalDateText);
    await prefs.setInt('daysCounter', daysCounter);
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

  void selectNoticeTime(TimeOfDay t) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var now = DateTime.now();
    var dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    this.noticeTime = (DateFormat.Hm()).format(dt);
    this.noticeHour = t.hour;
    this.noticeMin = t.minute;
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    await prefs.setString('noticeTime', noticeTime);
    await prefs.setInt('noticeHour', noticeHour);
    await prefs.setInt('noticeMin', noticeMin);
    notifyListeners();
  }

  //textFieldで数を入力
  void inputDaysCounter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    this.daysCounter = int.parse(putTodayCounter);
    this.goalDate = startDate.add(Duration(days: (daysCounter - 1)));
    setTimeStampFromGoalDate(prefs, goalDate);
    this.goalDateText = outputFormat.format(goalDate);
    if (isPushedOn) resetNotice(goalDate, noticeHour, noticeMin);
    await prefs.setInt('daysCounter', daysCounter);
    await prefs.setString('goalDateText', goalDateText);
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

  //  通知設定
  void resetNotice(DateTime goalDate, int pushHour, int pushMin) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    scheduleNoticeDate(goalDate, pushHour, pushMin);
  }

  void scheduleNoticeDate(DateTime date, int hour, int min) async {
    if (noticeDateGroupValue == 0) {
      noticeBody = '明日でレンズの期限が切れます';
      noticeDate = goalDate.add(Duration(days: -1));
    } else if (noticeDateGroupValue == 1) {
      noticeBody = '今日でレンズの期限が切れます';
      noticeDate = goalDate;
    }

    await _configureLocalTimeZone();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '使用期限通知',
        noticeBody,
        _nextInstanceOfNoticeDate(date, hour, min),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'notification channel id',
            'notification channel name',
            'notification description',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfNoticeDate(DateTime date, int hour, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // year, month, day, hour, minutes, second
    //TODO 指定した日時に設定する
    // tz.TZDateTime scheduledDate =
    //     tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, 0);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, date.year, date.month, date.day, hour, min);
    return scheduledDate;
  }

  //ローカル時間の設定
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  void initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //onNotificationClick(payload); // your call back to the UI
    });
  }
}
