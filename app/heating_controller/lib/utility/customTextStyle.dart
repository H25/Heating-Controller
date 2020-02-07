import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextStyle {

  static TextStyle tempDisplay(BuildContext context) {
    return TextStyle(color: Theme.of(context).accentColor, fontSize: 30, fontWeight: FontWeight.bold);
  }

  static TextStyle bufferZoneDisplay(BuildContext context) {
    return TextStyle(color: Theme.of(context).accentColor, fontSize: 20, fontWeight: FontWeight.bold);
  }
}