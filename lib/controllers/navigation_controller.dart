import 'package:flutter/material.dart';

class NavigationController {
  static push(BuildContext context, Widget widget, {int durationMs = 300}) {
    Navigator.of(context).push(
      MyRoute(
        builder: (BuildContext context) {
          return widget;
        },
        transitionDuration: durationMs,
      ),
    );
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static replace(BuildContext context, Widget widget, {int durationMs = 300}) {
    Navigator.of(context).pushReplacement(
      MyRoute(
        builder: (BuildContext context) {
          return widget;
        },
        transitionDuration: durationMs,
      ),
    );
  }
}

class MyRoute extends MaterialPageRoute<void> {
  late int _transitionDuration;

  MyRoute({required WidgetBuilder builder, transitionDuration = 300}) : super(builder: builder) {
    _transitionDuration = transitionDuration;
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: _transitionDuration);
}