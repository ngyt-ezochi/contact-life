import 'package:contact_life/presantation/main_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  final btnWidth = 40.0;
  final _url = 'https://zenn.dev/ezochi66/scraps/a0426c317cb8a4';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel()
        ..getDate()
        ..getDaysCounter()
        ..getLensStock()
        ..getWasherStock()
        ..getNotification(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('設定'),
        ),
        body: Consumer<MainModel>(
          builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        _startDateCard(context, model),
                        _daysCounterCard(context, model),
                        _lensStockCard(context, model),
                        _washerStockCard(context, model),
                        _noticeCard(context, model),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: InkWell(
                            child: Text('プライバシーポリシー（外部サイトへ）'),
                            onTap: () async {
                              _launchURL();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future _selectedDate(BuildContext context, MainModel model) async {
    DateTime? selectedStartDate = await showDatePicker(
      context: context,
      locale: const Locale("ja"),
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (selectedStartDate != null) {
      model.selectStartDate(selectedStartDate);
    } else if (selectedStartDate == null) {
      print('選択日がnull');
    }
  }

  Future _selectNoticeTime(BuildContext context, MainModel model) async {
    TimeOfDay? selectedNoticeTime = await showTimePicker(
      context: context,
      // initialTime: TimeOfDay.now(),
      initialTime: model.noticeTimeOfDay,
    );

    if (selectedNoticeTime != null) {
      model.selectNoticeTime(selectedNoticeTime);
    } else if (selectedNoticeTime == null) {
      print('選択時間がnull');
    }
  }

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  _startDateCard(BuildContext context, MainModel model) => Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('開始日'),
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            // border:
                            //     Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '${model.startDateText}',
                            // '7月1日',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        onTap: () async {
                          _selectedDate(context, model);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _daysCounterCard(BuildContext context, MainModel model) => Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('使用期限'),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 220,
                        //  TODO picker入れる
                        child: CupertinoSlidingSegmentedControl(
                          children: model.maxDays,
                          groupValue: model.daysGroupValue,
                          onValueChanged: (changeFormGroupValue) {
                            model.slidingDaysControl(
                              changeFormGroupValue,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                        child: ButtonBar(
                          children: [
                            InkWell(
                              onTap: () {
                                //  TODO 日にち減らす
                                model.decrementDaysCounter();
                              },
                              child: Container(
                                width: btnWidth,
                                height: 30,
                                decoration: ShapeDecoration(
                                  color: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                ),
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: ShapeDecoration(
                                        color: Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            12.0, 8.0, 12.0, 8.0),
                                        child: SizedBox(
                                          width: 20,
                                          child: Text(
                                            //TODO 変数にする
                                            '${model.daysCounter}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _showChangeDaysCounter(context, model);
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                model.incrementDaysCounter();
                              },
                              child: Container(
                                width: btnWidth,
                                height: 30,
                                decoration: ShapeDecoration(
                                  color: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _lensStockCard(BuildContext context, MainModel model) => Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('レンズ数'),
                  Column(
                    children: [
                      ButtonBar(
                        children: [
                          InkWell(
                            onTap: () {
                              model.decrementLensStock();
                              //  TODO　ストック減らす
                            },
                            child: Container(
                              width: btnWidth,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 8.0, 12.0, 8.0),
                                      child: SizedBox(
                                        width: 20,
                                        child: Text(
                                          '${model.lensStock}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showChangeLensStock(context, model);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO ストック1増やす
                              model.incrementLensStock(1);
                            },
                            child: Container(
                              width: btnWidth,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ButtonBar(
                        children: [
                          InkWell(
                            onTap: () {
                              //TODO ストック5増やす
                              model.incrementLensStock(5);
                            },
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '＋5',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO ストック10増やす
                              model.incrementLensStock(10);
                            },
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '＋10',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _washerStockCard(BuildContext context, MainModel model) => Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('洗浄液'),
                  Column(
                    children: [
                      ButtonBar(
                        children: [
                          InkWell(
                            onTap: () {
                              //TODO 洗浄液減らす
                              model.decrementWasherStock();
                            },
                            child: Container(
                              width: btnWidth,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: ShapeDecoration(
                                      color: Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12.0, 8.0, 12.0, 8.0),
                                      child: SizedBox(
                                        width: 20,
                                        child: Text(
                                          // '${model.washerStock}'
                                          '${model.washerStock}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showChangeWasherStock(context, model);
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO  洗浄液1増やす
                              model.incrementWasherStock(1);
                            },
                            child: Container(
                              width: btnWidth,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ButtonBar(
                        children: [
                          InkWell(
                            onTap: () {
                              //TODO  洗浄液５増やす
                              model.incrementWasherStock(5);
                            },
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '＋5',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              //TODO  洗浄液10増やす
                              model.incrementWasherStock(10);
                            },
                            child: Container(
                              width: 70,
                              height: 30,
                              decoration: ShapeDecoration(
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '＋10',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _noticeCard(BuildContext context, MainModel model) => Container(
        decoration: BoxDecoration(
          border: const Border(
            bottom: const BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('通知機能'),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                    child: CupertinoSwitch(
                      value: model.isPushedOn,
                      onChanged: (value) {
                        model.changeSwitch();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('通知日'),
                    SizedBox(
                      width: 150,
                      child: CupertinoSlidingSegmentedControl(
                        children: model.noticeDateSet,
                        groupValue: model.noticeDateGroupValue,
                        onValueChanged: (changeFormGroupValue) {
                          model.slidingPushDateControl(
                            changeFormGroupValue,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('通知時間'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Text(
                            '${model.noticeTime}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          onTap: () async {
                            _selectNoticeTime(context, model);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  //キーボードで変数を入力
  _showChangeDaysCounter(BuildContext context, MainModel model) => showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text('期間の入力'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '使用期限',
                      ),
                      autofocus: true,
                      onChanged: (num) {
                        if (num != '') model.putTodayCounter = num;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  model.inputDaysCounter();
                },
              ),
            ],
          );
        },
      );

  _showChangeLensStock(BuildContext context, MainModel model) => showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text('レンズの数'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'レンズの数',
                      ),
                      autofocus: true,
                      onChanged: (num) {
                        if (num != '') model.putLensStock = num;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  model.inputLensStock();
                },
              ),
            ],
          );
        },
      );

  _showChangeWasherStock(BuildContext context, MainModel model) => showDialog(
        context: context,
        useRootNavigator: false,
        builder: (context) {
          return AlertDialog(
            title: Text('洗浄液の数'),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '洗浄液の数',
                      ),
                      autofocus: true,
                      onChanged: (num) {
                        if (num != '') model.putWasherStock = num;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  model.inputWasherStock();
                },
              ),
            ],
          );
        },
      );
}
