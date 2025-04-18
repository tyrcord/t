// Dart imports:
import 'dart:developer' as developer;

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:tenhance/tenhance.dart';

// Project imports:
import 'package:tlogger/logger.dart';

/// Custom logger class for application logging.
class TLogger {
  late final Function(String) _outputFunction;
  final String _labelTimeColorCode;
  final String _labelColorCode;
  final String label;

  bool isEnabled;
  LogLevel level;

  /// Constructor for TLogger.
  ///
  /// [label] - Identifier for the log source.
  /// [level] - Minimum level of logs to output.
  /// [isEnabled] - Flag to enable or disable logging.
  /// [labelColor] - Color code for the label.
  /// [labelTimeColor] - Color code for the timestamp.
  /// [outputFunction] - Custom function for outputting logs.
  TLogger(
    this.label, {
    this.level = LogLevel.debug,
    this.isEnabled = true,
    String labelColor = "\x1B[35m", // Magenta
    String labelTimeColor = "\x1B[34m", // Blue
    Function(String)? outputFunction,
  })  : _labelColorCode = labelColor,
        _labelTimeColorCode = labelTimeColor {
    _outputFunction = outputFunction ?? developer.log;
  }

  void warning(String message) => _printLog(message, LogLevel.warning);
  void debug(String message) => _printLog(message, LogLevel.debug);

  void info(String message, [dynamic value]) {
    if (value != null) {
      _printLog('$message => $value', LogLevel.info);
    } else {
      _printLog(message, LogLevel.info);
    }
  }

  void error(String message, [StackTrace? stackTrace]) {
    _printLog(message, LogLevel.error);

    if (stackTrace != null) _printStackTrace(stackTrace);
  }

  String padZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  String padZeroMilliseconds(int number) {
    return number.toString().padLeft(3, '0');
  }

  void _printStackTrace(StackTrace stackTrace) {
    final formattedStackTrace = _formatStackTrace(stackTrace);
    _printLog(formattedStackTrace, LogLevel.error);
  }

  String _formatStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    final formattedLines = lines.map((line) => line.trim());

    return formattedLines.join('\n');
  }

  /// Applies color based on log level.
  String _colorize(
    String message, {
    LogLevel? messageLevel,
    String? colorCode,
  }) {
    assert(messageLevel != null || colorCode != null);
    colorCode ??= _getColorCode(messageLevel!);

    return "$colorCode$message\x1B[0m"; // Reset to default at the end
  }

  /// Returns the color code for the given log level.
  String _getColorCode(LogLevel messageLevel) {
    switch (messageLevel) {
      case LogLevel.debug:
        return "\x1B[36m"; // Cyan
      case LogLevel.warning:
        return "\x1B[33m"; // Yellow
      case LogLevel.error:
        return "\x1B[31m"; // Red
      case LogLevel.info:
        return "\x1B[32m"; // Green
    }
  }

  String _getTime() {
    final DateTime now = DateTime.now();

    return "${padZero(now.hour)}:${padZero(now.minute)}:${padZero(now.second)}."
        "${padZeroMilliseconds(now.millisecond)}";
  }

  /// Prints the log message if the conditions are met.
  void _printLog(String message, LogLevel messageLevel) {
    final coloredMessage = _colorize(message, messageLevel: messageLevel);
    final coloredLabel = _colorize('[$label]', colorCode: _labelColorCode);
    final levelString = messageLevel.name.toUpperCase();
    final formattedTime = _getTime();

    final coloredTimestamp = _colorize(
      '[$formattedTime]',
      colorCode: _labelTimeColorCode,
    );

    final coloredLevel = _colorize(
      '[$levelString]',
      messageLevel: messageLevel,
    );

    final logEntryWithoutColors =
        '[$formattedTime] [$label] [$levelString] $message';

    // Record log in TLoggerJournal
    TLoggerJournal().recordLog(logEntryWithoutColors);

    if (!isEnabled || !kDebugMode || messageLevel < level) return;

    final logEntry =
        '$coloredTimestamp $coloredLabel $coloredLevel $coloredMessage';

    _outputFunction(logEntry);
  }
}
