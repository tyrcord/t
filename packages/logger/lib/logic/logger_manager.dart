import 'package:tlogger/logger.dart';

class TLoggerManager {
  static final TLoggerManager _instance = TLoggerManager._internal();
  final Map<String, Logger> _loggers = {};

  factory TLoggerManager() => _instance;

  TLoggerManager._internal();

  Logger getLogger(String label, {LogLevel level = LogLevel.debug}) {
    return _loggers.putIfAbsent(label, () => Logger(label, level: level));
  }

  void setLogLevel(String label, LogLevel level) {
    final logger = _loggers[label];

    if (logger != null) {
      logger.level = level;
    }
  }

  void enableLogger(String label) {
    final logger = _loggers[label];

    if (logger != null) {
      logger.isEnabled = true;
    }
  }

  void disableLogger(String label) {
    final logger = _loggers[label];

    if (logger != null) {
      logger.isEnabled = false;
    }
  }

  void enableLoggers(List<String> labels) {
    for (final label in labels) {
      enableLogger(label);
    }
  }

  void disableLoggers(List<String> labels) {
    for (final label in labels) {
      disableLogger(label);
    }
  }

  void disableAllLoggers() {
    disableLoggers(_loggers.keys.toList());
  }

  void clearLoggers() {
    disableAllLoggers();

    _loggers.clear();
  }
}
