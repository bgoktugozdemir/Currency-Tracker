import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

class Api {
  static String _apiLink = "https://kur.doviz.com/serbest-piyasa";

  static Future getDatas() async {
    final response = await http.get(_apiLink);

    if (response.statusCode == 200)
      return _parseDatas(parse(response.body));
    else
      return null;
  }

  static Map<dynamic,dynamic> _parseDatas(Document document) {
    var datas = Map<dynamic, dynamic>();

    var currencies = [
      ["USD", 0],
      ["EURO", 1],
      ["HUF", 22]
    ];

    var cells = [
      ["Currency_Name", 0],
      ["Currency_Buy", 1],
      ["Currency_Sell", 2],
      ["Currency_Difference", 3],
    ];

    var rows = document.querySelectorAll('tr[data-table-subpage-key]');


    currencies.forEach((currencyInfo) {
      var currency = rows[currencyInfo[1]];
      var currencyData = Map<String, String>();
      cells.forEach((cell) {
        currencyData.addAll({cell[0]: currency.children[cell[1]].text.trim()});
      });
      datas.addAll({currencyInfo[0]: currencyData});
    });
    return datas;
  }
}
