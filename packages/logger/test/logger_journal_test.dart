// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tlogger/logger.dart';

void main() {
  group('TLoggerJournal', () {
    test('should record log entries', () {
      final loggerJournal = TLoggerJournal(maxSize: 10)
        ..recordLog('Test log 1')
        ..recordLog('Test log 2');

      expect(loggerJournal.logs, contains('Test log 1'));
      expect(loggerJournal.logs, contains('Test log 2'));
    });

    test('should respect the log size limit', () {
      const maxSize = 5;
      final loggerJournal = TLoggerJournal(maxSize: maxSize);

      for (int i = 0; i < 10; i++) {
        loggerJournal.recordLog('Log $i');
      }

      expect(loggerJournal.logs.length, equals(maxSize));
    });

    test('should update the maximum size of log entries', () {
      const initialSize = 5;
      const updatedSize = 3;

      final loggerJournal = TLoggerJournal(maxSize: initialSize);

      for (int i = 0; i < 5; i++) {
        loggerJournal.recordLog('Log $i');
      }

      loggerJournal.setMaxSize(updatedSize);

      expect(loggerJournal.logs.length, 3);
    });
  });
}
