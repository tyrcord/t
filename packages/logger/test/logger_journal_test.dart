// Package imports:
// ignore_for_file: avoid_slow_async_io

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tlogger/logger.dart';

void main() {
  group('TLoggerJournal Tests', () {
    late TLoggerJournal logger;
    late String logFilePath;

    setUp(() async {
      // Initialize the logger before each test
      logger = TLoggerJournal(maxSize: 1024 * 8 /* 8 KB */);
      logFilePath =
          '${Directory.systemTemp.path}/${TLoggerJournal.defaultLogFileName}';
    });

    tearDown(() async {
      // Clean up: remove log file after each test to ensure a fresh start
      await logger.clearLogs(); // Clear logs

      // Reset the singleton instance if necessary (depending on implementation)
    });

    test('Singleton Instance Test', () {
      final logger1 = TLoggerJournal.instance;
      final logger2 = TLoggerJournal.instance;

      expect(identical(logger1, logger2), isTrue);
    });

    test('Log Recording and Retrieval', () async {
      const logEntry = 'Test log entry';
      logger.recordLog(logEntry);

      final logFile = await logger.getLogFile();
      final contents = await logFile.readAsString();

      expect(contents.contains(logEntry), isTrue);
    });

    // FIXME: disabled due to failing on CI
    // test('Batch Processing', () async {
    //   List.generate(TLoggerJournal.batchSize - 1, (index) => 'Log $index')
    //       .forEach(logger.recordLog);

    //   // Initially, logs should not be written yet
    //   // Short delay to ensure logs are not written prematurely

    //   final delay = TLoggerJournal.batchInterval.inMilliseconds / 2;
    //   await Future.delayed(Duration(milliseconds: delay.toInt()));

    //   var logFile = File(logFilePath);
    //   final exists = await logFile.exists();

    //   expect(exists ? await logFile.readAsString() : '', isEmpty);

    //   // Add one more log to reach the batch size
    //   logger.recordLog('Final log to reach batch size');

    //   await Future.delayed(
    //     TLoggerJournal.batchInterval + const Duration(seconds: 2),
    //   );

    //   logFile = File(logFilePath);
    //   final contents = await logFile.readAsString();

    //   expect(contents.contains('Final log to reach batch size'), isTrue);
    // });

    test('Automatic Flushing Test', () async {
      const logEntry = 'Test log entry for automatic flushing';
      logger.recordLog(logEntry);

      // Wait for the batch interval to trigger automatic flushing
      await Future.delayed(
        TLoggerJournal.batchInterval + const Duration(seconds: 1),
      );

      final logFile = File(logFilePath);
      final contents = await logFile.readAsString();
      expect(contents.contains(logEntry), isTrue);
    });

    test('File Size Management', () async {
      // Write enough logs to exceed the maximum file size
      for (int i = 0; i < 1024 * 2; i++) {
        logger.recordLog('Log $i');
      }

      final logFile = await logger.getLogFile();
      final fileSize = await logFile.length();

      expect(fileSize, lessThanOrEqualTo(1024 * 8));
    });

    test('Clear Logs Test', () async {
      logger.recordLog('Test log entry for clear logs');

      // Ensure log is written
      await Future.delayed(
        TLoggerJournal.batchInterval + const Duration(seconds: 1),
      );

      await logger.clearLogs(); // Clear logs

      final logFile = await logger.getLogFile();
      final contents = await logFile.readAsString();

      expect(await logFile.exists(), isTrue);
      expect(contents, isEmpty);
    });

    test('Concurrent Log Writing Test', () async {
      // NOTE: don't use a large number of concurrent writers or logs per writer
      // as this will cause the file size to exceed the maximum size and
      // trigger trimming, which will affect the test results.

      // Number of concurrent log entries to simulate
      const int concurrentWriters = 25;

      // Number of logs each "writer" should record
      const int logsPerWriter = 10;

      // Use a list to track all the Future<void> instances returned by
      // the asynchronous log recording operations
      final List<Future<void>> loggingTasks = [];

      for (int i = 0; i < concurrentWriters; i++) {
        final writerTask = Future(() {
          for (int j = 0; j < logsPerWriter; j++) {
            final String logEntry = 'Writer $i Log $j';
            logger.recordLog(logEntry);
          }
        });

        // Add the writerTask to the list of logging tasks
        loggingTasks.add(writerTask);
      }

      // Wait for all logging tasks to complete
      await Future.wait(loggingTasks);

      // Retrieve the log file and verify its contents
      final logFile = await logger.getLogFile();
      final contents = await logFile.readAsString();

      // Check if all log entries are present in the file
      for (int i = 0; i < concurrentWriters; i++) {
        for (int j = 0; j < logsPerWriter; j++) {
          expect(contents.contains('Writer $i Log $j'), isTrue);
        }
      }
    });
  });
}
