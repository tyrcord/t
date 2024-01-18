// Dart imports:
import 'dart:async';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('retry function tests', () {
    test('Successfully returns value without any retries', () async {
      final result = await retry<String>(
        task: () async => 'Success!',
      );

      expect(result, 'Success!');
    });

    test('Successfully returns value after some retries', () async {
      int attemptCounter = 0;
      final result = await retry<String>(
        task: () async {
          attemptCounter++;

          if (attemptCounter < 3) {
            throw Exception('Simulated error.');
          }

          return 'Success after retries!';
        },
        maxAttempts: 5,
      );

      expect(result, 'Success after retries!');
      expect(attemptCounter, 3);
    });

    test('Fails after maxAttempts reached', () async {
      int attemptCounter = 0;

      final future = retry<String>(
        task: () async {
          attemptCounter++;
          throw Exception('Simulated error.');
        },
        maxAttempts: 3,
      );

      await expectLater(
        future,
        throwsA(isA<Exception>()),
      );
      expect(attemptCounter, 3);
    });

    test('Retries when validation fails', () async {
      int attemptCounter = 0;

      final result = await retry<String>(
        task: () async {
          attemptCounter++;
          return attemptCounter < 3 ? 'Invalid' : 'Valid';
        },
        maxAttempts: 5,
        validate: (res) => res == 'Valid',
      );

      expect(result, 'Valid');
      expect(attemptCounter, 3);
    });

    test('Waits the correct delay between retries', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await retry<String>(
          task: () async {
            throw Exception('Simulated error.');
          },
          maxAttempts: 4,
          initialDelay: const Duration(seconds: 2),
        );
      } catch (_) {
        // 2 + 4 + 8 seconds
        expect(
          stopwatch.elapsed,
          greaterThanOrEqualTo(const Duration(seconds: 14)),
        );
        expect(
          stopwatch.elapsed,
          lessThanOrEqualTo(const Duration(seconds: 15)),
        );
      } finally {
        stopwatch.stop();
      }
    });

    test('Honors maxDelay for retries', () async {
      final stopwatch = Stopwatch()..start();

      try {
        await retry<String>(
          task: () async {
            throw Exception('Simulated error.');
          },
          maxAttempts: 4,
          initialDelay: const Duration(seconds: 2),
          maxDelay: const Duration(seconds: 3),
        );
      } catch (_) {
        //  2 + 3 + 3 seconds
        expect(
          stopwatch.elapsed,
          greaterThanOrEqualTo(const Duration(seconds: 8)),
        );
        expect(
          stopwatch.elapsed,
          lessThanOrEqualTo(const Duration(seconds: 9)),
        );
      } finally {
        stopwatch.stop();
      }
    });

    test('retry function should time out if task exceeds taskTimeout',
        () async {
      Future<String> longRunningTask() async {
        await Future.delayed(const Duration(seconds: 5));

        return 'Completed';
      }

      try {
        final result = await retry<String>(
          task: longRunningTask,
          maxAttempts: 3,
          taskTimeout: const Duration(seconds: 2),
        );
        fail('Expected to throw TimeoutException but got result: $result');
      } on TimeoutException catch (e) {
        expect(e.toString(), contains('Task timed out after 2 seconds.'));
      }
    });
  });
}
