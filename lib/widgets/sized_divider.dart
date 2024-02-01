import 'package:flutter/material.dart';

class SizedDivider extends Divider {
  final double? vertical;
  final double? horizontal;

  const SizedDivider({super.key, this.vertical, this.horizontal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal ?? 0.0, vertical: vertical ?? 0.0),
      child: super.build(context),
    );
  }
}