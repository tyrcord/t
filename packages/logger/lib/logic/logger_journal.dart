class TLoggerJournal {
  static final TLoggerJournal _instance = TLoggerJournal._internal();
  final List<String> _logEntries = [];
  late int _maxSize;

  /// Returns all log entries.
  List<String> get logs => List.unmodifiable(_logEntries);

  factory TLoggerJournal({int maxSize = 1000}) {
    _instance._maxSize = maxSize;

    return _instance;
  }

  TLoggerJournal._internal();

  /// Records a log entry.
  void recordLog(String log) {
    if (_logEntries.length >= _maxSize) {
      _logEntries.removeAt(0); // Removes the oldest log entry to maintain size
    }

    _logEntries.add(log);
  }

  /// Sets the maximum size of the log list.
  void setMaxSize(int maxSize) {
    _maxSize = maxSize;

    while (_logEntries.length > _maxSize) {
      _logEntries.removeAt(0);
    }
  }

  /// Clears all log entries.
  void clearLogs() {
    _logEntries.clear();
  }
}
