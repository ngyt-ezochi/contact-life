import 'dart:io';
import 'package:contact_life/presentation/main/main_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'presentation/main/component/circle_painer.dart';
import 'presentation/setting/page/setting_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],
    );
  }
}

class MyHomePage extends StatelessWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final size = 240.0;
  final percentage = 0.7;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      _requestIOSPermission();
      _initializePlatformSpecifics();
    }
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('コンタクト管理'),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingPage(),
                  ),
                );
              },
            )
          ],
        ),
        body: Consumer<MainModel>(builder: (context, model, child) {
          model.getDate();
          model.getDaysCounterAndPercentage();
          // model.getDaysCounter();
          model.getLensStock();
          model.getWasherStock();
          return Column(
            children: [
              Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 80.0, 0, 20.0),
                            child: CustomPaint(
                              painter: CirclePainter(
                                percentage: model.percentage,
                                circleRadius: size * 0.5,
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Material(
                                  borderRadius:
                                      BorderRadius.circular(size * 0.5),
                                  child: Container(
                                    width: size,
                                    height: size,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('残り'),
                                                SizedBox(
                                                  width: 70,
                                                  child: Text(
                                                    '${model.todayCounter}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 50,
                                                    ),
                                                  ),
                                                ),
                                                Text('日'),
                                              ],
                                            ),
                                          ),
                                          Text(
                                              '${model.startDateText}~${model.goalDateText}'),
                                          // '6月21日~7月4日',),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('レンズ：残り'),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        '${model.lensStock}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                ElevatedButton(
                                  child: Text('レンズを交換する'),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text('レンズの交換確認'),
                                            content: Text('レンズを交換しますか？'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: Text('キャンセル'),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  //TODO レンズのカウントを−１する
                                                  model
                                                      .decrementLensStockAndResetStartDate();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('洗浄液：残り'),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        '${model.washerStock}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                ElevatedButton(
                                  child: Text('洗浄液を交換する'),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text('洗浄液の交換確認'),
                                            content: Text('洗浄液を交換しますか？'),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                child: Text('キャンセル'),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              CupertinoDialogAction(
                                                child: Text('OK'),
                                                onPressed: () async {
                                                  //TODO 洗浄液のカウントを−１する
                                                  model.decrementWasherStock();
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  //通知機能の設定
  void _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: false,
          badge: true,
          sound: false,
        );
  }

  void _initializePlatformSpecifics() {
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

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        //onNotificationClick(payload); // your call back to the UI
      },
    );
  }
}
