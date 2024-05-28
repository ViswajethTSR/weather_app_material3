import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastManager {
  static void showToast({required String? msg, ToastGravity gravity = ToastGravity.BOTTOM}) {
    Fluttertoast.showToast(
        backgroundColor: Colors.green.shade100.withOpacity(1),
        textColor: Colors.green.shade900,
        gravity: gravity,
        msg: msg ?? "",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 4);
  }

  static void showToastShort({required String msg}) {
    Fluttertoast.showToast(
        backgroundColor: Colors.green.shade100.withOpacity(1),
        textColor: Colors.green.shade900,
        gravity: ToastGravity.BOTTOM,
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2);
  }
}
