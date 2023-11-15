import 'dart:developer' show log;

import 'package:flutter/foundation.dart';
import 'package:tenhance/tenhance.dart';
import 'package:tlogger/logger.dart';
import 'package:intl/intl.dart';

class TLogger {
  static final _formatter = DateFormat('HH:mm:ss.SSS');

  late final Function(String) outputFunction;
  final String labelTimeColorCode;
  final String labelColorCode;
  final String label;

  bool isEnabled;
  LogLevel level;

  TLogger(
    this.label, {
    this.level = LogLevel.debug,
    this.isEnabled = true,
    String labelColor = "\x1B[35m", // Magenta
    String labelTimeColor = "\x1B[34m", // Blue
    Function(String)? outputFunction,
  })  : labelColorCode = labelColor,
        labelTimeColorCode = labelTimeColor {
    this.outputFunction = outputFunction ?? log;
  }

  void debug(String message) => _printLog(message, LogLevel.debug);
  void warning(String message) => _printLog(message, LogLevel.warning);
  void error(String message) => _printLog(message, LogLevel.error);
  void info(String message) => _printLog(message, LogLevel.info);

  String _colorize(String message, LogLevel messageLevel) {
    String colorCode;
    switch (messageLevel) {
      case LogLevel.debug:
        colorCode = "\x1B[36m"; // Cyan
      case LogLevel.warning:
        colorCode = "\x1B[33m"; // Yellow
      case LogLevel.error:
        colorCode = "\x1B[31m"; // Red
      case LogLevel.info:
        colorCode = "\x1B[32m"; // Green
      default:
        colorCode = "\x1B[0m"; // Default
    }

    return "$colorCode$message\x1B[0m"; // Reset to default at the end
  }

  void _printLog(String message, LogLevel messageLevel) {
    if (!isEnabled || !kDebugMode || messageLevel < level) return;

    final formattedTime = _formatter.format(DateTime.now());
    final coloredTimestamp = "$labelTimeColorCode[$formattedTime]\x1B[0m";
    final coloredMessage = _colorize(message, messageLevel);
    final coloredLabel = "$labelColorCode[$label]\x1B[0m";
    final levelString = messageLevel.name.toUpperCase();
    final coloredLevel = _colorize('[$levelString]', messageLevel);

    outputFunction(
      '$coloredTimestamp $coloredLabel $coloredLevel $coloredMessage',
    );
  }
}
