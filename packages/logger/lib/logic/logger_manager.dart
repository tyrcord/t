import 'package:tlogger/logger.dart';

/// Manages instances of TLogger for different labels.
class TLoggerManager {
  static final TLoggerManager _instance = TLoggerManager._internal();
  final Map<String, TLogger> _loggers = {};

  /// Factory constructor to provide a singleton instance.
  factory TLoggerManager() => _instance;

  /// Internal constructor for singleton pattern.
  TLoggerManager._internal();

  /// Retrieves or creates a logger with the given label and log level.
  TLogger getLogger(String label, {LogLevel level = LogLevel.debug}) {
    return _loggers.putIfAbsent(label, () => TLogger(label, level: level));
  }

  /// Sets the log level for a specific logger.
  void setLogLevel(String label, LogLevel level) {
    final logger = _loggers[label];

    if (logger != null) logger.level = level;
  }

  /// Enables a logger with the given label.
  void enableLogger(String label) {
    _setLoggerEnabled(label, true);
  }

  /// Disables a logger with the given label.
  void disableLogger(String label) {
    _setLoggerEnabled(label, false);
  }

  /// Enables multiple loggers based on a list of labels.
  void enableLoggers(List<String> labels) {
    _setMultipleLoggersEnabled(labels, true);
  }

  /// Disables multiple loggers based on a list of labels.
  void disableLoggers(List<String> labels) {
    _setMultipleLoggersEnabled(labels, false);
  }

  /// Disables all loggers managed by this instance.
  void disableAllLoggers() {
    _setMultipleLoggersEnabled(_loggers.keys.toList(), false);
  }

  /// Clears all logger instances.
  void clearLoggers() {
    disableAllLoggers();
    _loggers.clear();
  }

  /// Removes a logger with the given label.
  void removeLogger(String label) {
    disableLogger(label);
    _loggers.remove(label);
  }

  /// Helper method to enable or disable a specific logger.
  void _setLoggerEnabled(String label, bool isEnabled) {
    final logger = _loggers[label];

    if (logger != null) logger.isEnabled = isEnabled;
  }

  /// Helper method to enable or disable multiple loggers.
  void _setMultipleLoggersEnabled(List<String> labels, bool isEnabled) {
    for (final label in labels) {
      _setLoggerEnabled(label, isEnabled);
    }
  }
}
