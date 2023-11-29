import 'dart:developer';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class UiUtils {
  UiUtils._privateConstructor();

  static final UiUtils _instance = UiUtils._privateConstructor();

  factory UiUtils() {
    return _instance;
  }
  bool isShowingFlushbar = false;
  double screenWidth = 0;
  double screenHeight = 0;
  void getDeviceSize({required BuildContext context}) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  Future<void> showFlushBar({
    required BuildContext context,
    required String title,
    required String message,
    required IconData icon,
    int duration = 4,
    bool isDismissible = true,
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) async {
    try {
      Flushbar myFlush = Flushbar(
        isDismissible: isDismissible,
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        borderRadius: BorderRadius.circular(20),
        flushbarStyle: FlushbarStyle.FLOATING,
        backgroundColor: Colors.orange,
        title: title,
        message: message,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        duration: Duration(
          seconds: duration,
        ),
        flushbarPosition: position,
      );
      isShowingFlushbar = true;
      await myFlush.show(context).then(
            (_) async => await Future.delayed(
              Duration(seconds: duration),
              () => isShowingFlushbar = false,
            ),
          );
    } catch (error) {
      log(
        'showFlushbar error : $error',
      );
    }
  }
}
