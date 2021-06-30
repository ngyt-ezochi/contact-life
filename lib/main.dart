import 'package:contact_life/circle_painer.dart';
import 'package:contact_life/setting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final size = 200.0;
  final percentage = 0.7;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingModel>(
      create: (_) => SettingModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('コンタクト管理'),
        ),
        body: Consumer<SettingModel>(builder: (context, model, child) {
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
                                                    // '${model.todayCounter}',
                                                    '14',
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
                                              // '${model.startDateText}~${model.goalDateText}'),
                                              '6月21日~7月4日'),
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
                      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 0.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('レンズ：残り'),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        '6',
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
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('洗浄液：残り'),
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        '6',
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
                                                onPressed: () {
                                                  //TODO 洗浄液のカウントを−１する
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
}
