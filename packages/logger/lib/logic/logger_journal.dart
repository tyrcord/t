import 'dart:io';
import 'dart:async';

import 'package:t_helpers/helpers.dart';

class TLoggerJournal {
  static const int defaultMaxSize = 1024 * 1024 * 10; // 10 MB
  static const String defaultLogFileName = 'logs.txt';
  // Number of logs to write in one batch
  static const int batchSize = 256;
  // Time interval to flush logs
  static const Duration batchInterval = Duration(milliseconds: 500);

  static bool get hasBeenInstantiated => _hasBeenInstantiated;
  static bool _hasBeenInstantiated = false;

  static late TLoggerJournal _instance;

  static TLoggerJournal get instance {
    if (!_hasBeenInstantiated) return TLoggerJournal();

    return _instance;
  }

  late String _logFileName;
  late File _logFile;
  late int _maxSize;
  late IOSink _sink;

  final Map<Future, bool> _pendingTasks = {};

  List<String> _logQueue = [];
  bool _isTrimming = false;
  bool _isWriting = false;
  Timer? _batchTimer;

  TLoggerJournal._({
    String logFileName = defaultLogFileName,
    int maxSize = defaultMaxSize,
  }) {
    _logFileName = logFileName;
    _maxSize = maxSize;

    _initializeLogFile();
  }

  factory TLoggerJournal({
    String logFileName = defaultLogFileName,
    int maxSize = defaultMaxSize,
  }) {
    if (!_hasBeenInstantiated) {
      _instance = TLoggerJournal._(logFileName: logFileName, maxSize: maxSize);
      _hasBeenInstantiated = true;
    }

    return instance;
  }

  /// Returns the current log file, ensuring all pending writes and trimming
  /// are complete.
  Future<File> getLogFile() async {
    // Flush any remaining logs in the queue before proceeding
    await _flushRemainingLogs();
    await _waitForPendingTasks();

    return _logFile;
  }

  /// Records a log entry by adding it to the queue.
  void recordLog(String log) {
    _logQueue.add(log);

    // Start the timer if it's not already running and the queue has logs
    // to process
    if (_batchTimer == null || !_batchTimer!.isActive) _startBatchTimer();

    // Process the queue immediately if it reaches the batch size,
    // otherwise, it will be processed at the next interval.
    if (_logQueue.length >= batchSize) _processLogQueue();
  }

  /// Initializes the log file.
  void _initializeLogFile() {
    _logFile = File('${Directory.systemTemp.path}/$_logFileName');
    _sink = _logFile.openWrite();
  }

  /// Starts a timer to process log queue at regular intervals.
  void _startBatchTimer() {
    if (_batchTimer == null || !_batchTimer!.isActive) {
      _batchTimer = Timer.periodic(batchInterval, (_) {
        _filterCompletedTasks();
        _processLogQueue();
      });
    }
  }

  /// Processes the log queue in batches.
  Future<void> _processLogQueue() async {
    if (_logQueue.isEmpty || _isTrimming || _isWriting) {
      // Stop the timer if the queue becomes empty after processing this batch
      if (_logQueue.isEmpty) _stopBatchTimer();

      return;
    }

    _isWriting = true; // Indicate that a write operation is starting

    final List<String> batch = _logQueue.take(batchSize).toList();
    _logQueue = _logQueue.skip(batchSize).toList();

    // Wrap the writing process in a Future
    final writeTask = Future(() {
      for (final log in batch) {
        _sink.writeln(log);
      }

      return _sink.flush(); // Ensure that the data is written to the file
    }).then((_) => _checkAndTrimLogFile()); // Chain trimming after writing

    writeTask
        .catchError((error) => debugLog('Error writing logs: $error'))
        .whenComplete(() {
      _pendingTasks[writeTask] = true; // Mark the task as completed
      _isWriting = false; // Reset the flag after the write operation completes
    });

    _pendingTasks[writeTask] = false;

    // Stop the timer if the queue becomes empty after processing this batch
    if (_logQueue.isEmpty) _stopBatchTimer();

    return writeTask;
  }

  /// Checks the log file size and trims it if it exceeds the maximum
  /// allowed size.
  Future<void> _checkAndTrimLogFile() {
    final Future<void> trimTask = _sink.flush().then((_) async {
      final int fileSize = await _logFile.length();

      if (fileSize <= _maxSize || _isTrimming) return;

      _isTrimming = true;

      try {
        final int trimSize = (fileSize - _maxSize).toInt();
        final tempFile = File('${_logFile.path}_temp');
        final originalFile = await _logFile.open(mode: FileMode.read);
        await originalFile.setPosition(trimSize);
        final trimmedData = await originalFile.read(fileSize - trimSize);
        await tempFile.writeAsBytes(trimmedData, flush: true);
        await originalFile.close();
        await _logFile.delete();
        await tempFile.rename(_logFile.path);
        _sink = _logFile.openWrite(mode: FileMode.append);
      } finally {
        _isTrimming = false;
      }
    });

    trimTask
        .catchError((error) => debugLog('Error triming logs: $error'))
        // Mark the task as completed, regardless of success or failure
        .whenComplete(() => _pendingTasks[trimTask] = true);

    // Add the trim task to pending tasks
    _pendingTasks[trimTask] = false;

    return trimTask;
  }

  /// Sets the maximum size of the log list.
  void setMaxSize(int maxSize) {
    _maxSize = maxSize;
    _checkAndTrimLogFile();
  }

  /// Clears all log entries.
  Future<void> clearLogs() async {
    // Ensure all pending tasks are completed
    await Future.wait(_pendingTasks.keys);

    _pendingTasks.clear();
    _initializeLogFile();
  }

  void _filterCompletedTasks() {
    // Remove entries for completed tasks
    _pendingTasks.removeWhere((_, completed) => completed);
  }

  Future<void> _flushRemainingLogs() async {
    // Define a recursive helper function that processes the queue and waits
    // for each batch to complete before proceeding to the next batch.
    Future<void> processQueue() async {
      // Wait for all pending tasks to complete
      await _waitForPendingTasks();

      if (_logQueue.isNotEmpty) {
        await _processLogQueue(); // Process the current batch
        await processQueue(); // Recursively process the next batch
      }
    }

    // Start processing the queue
    await processQueue();
  }

  void _stopBatchTimer() {
    if (_batchTimer != null) {
      _batchTimer!.cancel();
      _batchTimer = null; // Clear the timer to indicate it's not running
    }
  }

  Future<void> _waitForPendingTasks() async {
    // Wait for all pending tasks to complete
    await Future.wait(_pendingTasks.keys);

    // Clear the list as all tasks are completed
    _pendingTasks.clear();
  }
}
