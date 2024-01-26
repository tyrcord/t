// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tlogger/logger.dart';

void main() {
  group('Logger Tests', () {
    late TLogger logger;
    late StringBuffer logOutput;
    late TLoggerJournal loggerJournal;

    setUp(() {
      logOutput = StringBuffer();
      logger = TLogger(
        'TestLogger',
        outputFunction: logOutput.writeln, // Capture output in the StringBuffer
      );
      loggerJournal = TLoggerJournal();
    });

    tearDown(() => loggerJournal.clearLogs());

    test('Logger initializes with default values', () {
      expect(logger.label, equals('TestLogger'));
      expect(logger.level, equals(LogLevel.debug));
      expect(logger.isEnabled, isTrue);
    });

    test('Logger respects log level settings', () {
      logger
        ..level = LogLevel.warning
        ..debug('This should not be printed');

      expect(logOutput.isEmpty, isTrue);
    });

    test('Logger can be enabled and disabled', () {
      logger
        ..isEnabled = false
        ..debug('This should not be printed');

      expect(logOutput.isEmpty, isTrue);
    });

    test('Log messages include timestamp', () {
      logger.debug('Test message');
      final expectedPattern = RegExp(r'\[\d{2}:\d{2}:\d{2}\.\d{3}\]');

      expect(logOutput.toString(), matches(expectedPattern));
    });

    test('Custom label and color are applied', () {
      TLogger(
        'Custom',
        labelColor: "\x1B[34m", // Blue
        outputFunction: logOutput.writeln,
      ).debug('Test message');

      expect(logOutput.toString(), contains('Custom'));
    });

    test('should colorize message based on log level', () {
      logger.warning('Warning message');
      expect(logOutput.toString(), contains('\x1B[33m'));
    });

    test(
        'Logs are recorded in the journal regardless of level or enabled state',
        () async {
      logger
        ..level = LogLevel.warning
        ..debug('This should not be printed but should be recorded')
        // Disable the logger and record another log
        ..isEnabled = false
        ..error('This should not be printed but should be recorded');

      TLogger(
        'Custom',
        labelColor: "\x1B[34m", // Blue
        outputFunction: logOutput.writeln,
      ).debug('Another message from another logger');

      // Check if logs are recorded in the journal
      final logs = await loggerJournal.getLogFile();
      final logContents = await logs.readAsString();

      expect(
        logContents,
        contains('This should not be printed but should be recorded'),
      );

      expect(logContents, contains('Another message from another logger'));
    });
  });
}
