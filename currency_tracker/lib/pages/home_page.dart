import 'dart:async';

import 'package:currency_tracker/api/api.dart';
import 'package:currency_tracker/utilities/tools.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<dynamic, dynamic> _oldDatas = {};
  Map<dynamic, dynamic> _datas = {};
  DateTime _lastUpdate = DateTime.now();
  @override
  void initState() {
    super.initState();
    getData();
    Timer.periodic(Duration(seconds: 15), (timer) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Column(
        children: <Widget>[
          Text("Currency Tracker"),
          Text(
            Tools.datetimeToString(_lastUpdate),
            style: TextStyle(fontSize: 8),
          )
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Container(
      child: ListView.builder(
          itemCount: _datas.length,
          itemBuilder: (BuildContext context, int index) {
            var data = _datas.values.elementAt(index);
            var oldData = (_oldDatas.length == 0)
                ? null
                : _oldDatas.values.elementAt(index);
            return Container(
              child: Card(
                color: (_oldDatas.length == 0 &&
                        _oldDatas.length != _datas.length
                    ? Colors.white
                    : (oldData["Currency_Buy"] != data["Currency_Buy"] ||
                            oldData["Currency_Sell"] != data["Currency_Sell"]
                        ? Colors.amber[100]
                        : Colors.white)),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: Tools.rotatedText(
                        data["Currency_Name"].toString().substring(0, 3) +
                            "\nTRY"),
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: Tools.rotatedText(
                      data["Currency_Difference"].toString(),
                      left: true,
                      colorful: true,
                    ),
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          _cardRate(data["Currency_Buy"]),
                          _cardRateTitle(buy: true)
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          _cardRate(data["Currency_Sell"]),
                          _cardRateTitle()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _cardRate(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _cardRateTitle({bool buy = false}) {
    return Text(
      (buy == true) ? "Alış" : "Satış",
      style: TextStyle(fontSize: 10),
    );
  }

  void getData() async {
    _oldDatas = _datas;
    _datas = await Api.getDatas();
    _lastUpdate = DateTime.now();
    setState(() {});
  }
}
