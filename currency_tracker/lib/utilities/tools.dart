import 'package:flutter/material.dart';

class Tools {
  static List<Widget> rotatedText(String text,
      {bool left = false, bool colorful = false}) {
    List<Widget> res = [];
    bool hasMinus = text.contains('-');
    var words = text.split(" ");
    for (var word in words) {
      res.add(RotatedBox(
          quarterTurns: (left == true ? 1 : 3),
          child: Text(
            word + ' ',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: (colorful == true
                  ? (hasMinus == true ? Colors.red : Colors.green)
                  : Colors.black),
            ),
          )));
    }
    return res;
  }

  static String datetimeToString(DateTime datetime){
    return "${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute}:${datetime.second}";
  }
}
