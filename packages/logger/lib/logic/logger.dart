import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:tenhance/tenhance.dart';
import 'package:tlogger/logger.dart';

/// Custom logger class for application logging.
class TLogger {
  static final _timeFormatter = DateFormat('HH:mm:ss.SSS');

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

  void debug(String message) => _printLog(message, LogLevel.debug);
  void warning(String message) => _printLog(message, LogLevel.warning);
  void error(String message) => _printLog(message, LogLevel.error);
  void info(String message) => _printLog(message, LogLevel.info);

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
      default:
        return "\x1B[0m"; // Default
    }
  }

  /// Prints the log message if the conditions are met.
  void _printLog(String message, LogLevel messageLevel) {
    final formattedTime = _timeFormatter.format(DateTime.now());
    final coloredMessage = _colorize(message, messageLevel: messageLevel);
    final coloredLabel = _colorize('[$label]', colorCode: _labelColorCode);
    final levelString = messageLevel.name.toUpperCase();

    final coloredTimestamp = _colorize(
      '[$formattedTime]',
      colorCode: _labelTimeColorCode,
    );

    final coloredLevel = _colorize(
      '[$levelString]',
      messageLevel: messageLevel,
    );

    final logEntry =
        '$coloredTimestamp $coloredLabel $coloredLevel $coloredMessage';

    // Record log in TLoggerJournal
    TLoggerJournal().recordLog(logEntry);

    if (!isEnabled || !kDebugMode || messageLevel < level) return;

    _outputFunction(logEntry);
  }
}
