import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterToastHelper {
  static Future showErrorToast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        backgroundColor: const Color(0xFFFF6464),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }

  static Future showSuccessToast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        backgroundColor: const Color(0xFF4CC285),
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }
}
