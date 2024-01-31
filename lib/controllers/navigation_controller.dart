import 'package:flutter/material.dart';

class NavigationController {
  static push(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static replace(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return widget;
        },
      ),
    );
  }
}