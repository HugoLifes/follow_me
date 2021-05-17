import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../inicio.dart';
import '../main.dart';

SharedPreferences prefs;

// ignore: must_be_immutable
class Validation extends StatefulWidget {
  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  open(value) async {
    await Validation.init();
    prefs.setInt('val', value);
  }

  var val = prefs.getInt('val');

  Validation({Key key}) : super(key: key);

  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  @override
  Widget build(BuildContext context) {
    return widget.val == 1 ? MyApp() : Inicio();
  }
}
