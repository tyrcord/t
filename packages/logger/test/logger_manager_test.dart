// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tlogger/logger.dart';

void main() {
  group('TLoggerManager Tests', () {
    group('TLoggerManager Tests', () {
      setUp(() {
        TLoggerManager().clearLoggers();
      });

      test('TLoggerManager should return the same instance', () {
        final instance1 = TLoggerManager();
        final instance2 = TLoggerManager();
        expect(identical(instance1, instance2), isTrue);
      });

      test('should create and retrieve a logger with a given label', () {
        final manager = TLoggerManager();
        final logger = manager.getLogger('testLogger');
        expect(manager.getLogger('testLogger'), equals(logger));
      });

      test('should create multiple loggers with different labels', () {
        final manager = TLoggerManager();
        final logger1 = manager.getLogger('logger1');
        final logger2 = manager.getLogger('logger2');
        expect(manager.getLogger('logger1'), equals(logger1));
        expect(manager.getLogger('logger2'), equals(logger2));
        expect(manager.getLogger('logger1'), isNot(equals(logger2)));
      });

      test('should correctly set log level of a logger', () {
        final manager = TLoggerManager();
        final logger = manager.getLogger('testLogger');
        manager.setLogLevel('testLogger', LogLevel.error);
        expect(logger.level, equals(LogLevel.error));
      });

      test('should disable and enable individual logger', () {
        final manager = TLoggerManager();
        final logger = manager.getLogger('testLogger');

        manager.disableLogger('testLogger');
        expect(logger.isEnabled, isFalse);

        manager.enableLogger('testLogger');
        expect(logger.isEnabled, isTrue);
      });

      test('should disable and enable multiple loggers', () {
        final manager = TLoggerManager()
          ..getLogger('logger1')
          ..getLogger('logger2')
          ..getLogger('logger3');

        final labels = ['logger1', 'logger2', 'logger3'];

        manager.disableLoggers(labels);

        for (final label in labels) {
          expect(manager.getLogger(label).isEnabled, isFalse);
        }

        manager.enableLoggers(labels);

        for (final label in labels) {
          expect(manager.getLogger(label).isEnabled, isTrue);
        }
      });
    });

    test('should remove a logger with a given label', () {
      final manager = TLoggerManager();
      final logger = manager.getLogger('testLogger');
      manager.removeLogger('testLogger');

      expect(manager.getLogger('testLogger'), isNot(equals(logger)));
      expect(logger.isEnabled, isFalse);
    });
  });
}
