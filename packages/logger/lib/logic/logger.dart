import 'package:flutter/foundation.dart';
import 'package:tlogger/logger.dart';

class Logger {
  late final Function(String) outputFunction;
  final String label;

  String labelColorCode; // Color code for the label
  bool isEnabled; // New property to control the logger state
  LogLevel level;

  Logger(
    this.label, {
    this.level = LogLevel.debug,
    this.isEnabled = true,
    String labelColor = "\x1B[35m", // Magenta
    Function(String)? outputFunction,
  }) : labelColorCode = labelColor {
    this.outputFunction = outputFunction ?? debugPrint;
  }

  void debug(String message) => _printLog(message, LogLevel.debug);
  void warning(String message) => _printLog(message, LogLevel.warning);
  void error(String message) => _printLog(message, LogLevel.error);
  void info(String message) => _printLog(message, LogLevel.info);

  String _colorize(String message, LogLevel messageLevel) {
    String colorCode;
    switch (messageLevel) {
      case LogLevel.debug:
        colorCode = "\x1B[32m"; // Green
      case LogLevel.warning:
        colorCode = "\x1B[33m"; // Yellow
      case LogLevel.error:
        colorCode = "\x1B[31m"; // Red
      case LogLevel.info:
        colorCode = "\x1B[34m"; // Blue
      default:
        colorCode = "\x1B[0m"; // Default
    }

    return "$colorCode$message\x1B[0m"; // Reset to default at the end
  }

  void _printLog(String message, LogLevel messageLevel) {
    if (!isEnabled || !kDebugMode || messageLevel.index < level.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final coloredMessage = _colorize(message, messageLevel);
    final coloredLabel = "$labelColorCode$label\x1B[0m";
    final levelString = messageLevel.name.toUpperCase();
    final coloredLevel = _colorize(levelString, messageLevel);

    outputFunction(
        '[$timestamp][$coloredLabel][$coloredLevel] $coloredMessage');
  }
}
