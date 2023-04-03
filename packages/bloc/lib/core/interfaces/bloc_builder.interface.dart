import 'package:flutter/material.dart';

abstract class IBlocBuilder {
  final WidgetBuilder? loadingBuilder;
  final bool waitForData;

  IBlocBuilder({
    this.waitForData = false,
    this.loadingBuilder,
  });
}
