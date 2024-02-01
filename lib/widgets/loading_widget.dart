import 'package:flutter/material.dart';

abstract class LoadingWidgetState<T extends StatefulWidget> extends State<T> {
  set isLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
  bool get isLoading {
    return _isLoading;
  }

  bool _isLoading = true;

  Widget buildLoading(Widget child) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return child;
    }
  }
}