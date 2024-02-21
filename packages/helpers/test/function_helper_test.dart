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

  group('Debounce Function', () {
    test('Basic Functionality', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final debouncedIncrement =
          debounce(incrementCounter, const Duration(milliseconds: 100));

      debouncedIncrement();
      // Ensure func has not been called immediately
      expect(callCount, 0, reason: 'Function should not be called immediately');

      // Wait for the delay to allow the function to be called
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1, reason: 'Function should be called after the delay');
    });

    test('Immediate Invocations', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final debouncedIncrement =
          debounce(incrementCounter, const Duration(milliseconds: 100));

      debouncedIncrement();
      debouncedIncrement();
      debouncedIncrement();

      // Wait for more than the delay
      await Future.delayed(const Duration(milliseconds: 150));

      expect(
        callCount,
        1,
        reason: 'Function should be called once after the delay',
      );
    });
    test('Debounce Effect', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final debouncedIncrement =
          debounce(incrementCounter, const Duration(milliseconds: 100));

      debouncedIncrement();

      await Future.delayed(const Duration(milliseconds: 50));
      debouncedIncrement();

      await Future.delayed(const Duration(milliseconds: 50));
      debouncedIncrement();

      await Future.delayed(const Duration(milliseconds: 50));
      debouncedIncrement();

      // Wait for the delay to pass
      await Future.delayed(const Duration(milliseconds: 150));

      expect(
        callCount,
        1,
        reason: 'Function should only be called once after the last debounce',
      );
    });
  });

  group('Debouncer Tests', () {
    test('Initialization', () {
      final debouncer = Debouncer(milliseconds: 100);
      expect(debouncer.milliseconds, 100);
    });

    test('Basic Debounce Functionality', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      Debouncer(milliseconds: 100).run(incrementCounter);

      // Action should not be called immediately
      expect(callCount, 0, reason: 'Action should not be called immediately');

      // Wait for the delay to pass
      await Future.delayed(const Duration(milliseconds: 150));
      expect(callCount, 1, reason: 'Action should be called after the delay');
    });

    test('Debounce Effect', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final debouncer = Debouncer(milliseconds: 100);

      // Call run multiple times in quick succession
      // ignore: cascade_invocations
      debouncer
        ..run(incrementCounter)
        ..run(incrementCounter)
        ..run(incrementCounter);

      // Wait for the delay to pass
      await Future.delayed(const Duration(milliseconds: 150));

      expect(
        callCount,
        1,
        reason: 'Action should only be executed once after the last call',
      );
    });

    test('Cancellation', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final debouncer = Debouncer(milliseconds: 100);

      // ignore: cascade_invocations
      debouncer
        ..run(incrementCounter)
        // Cancel the previous action and schedule a new one
        ..run(() {
          callCount += 10;
        });

      // Wait for the delay to pass
      await Future.delayed(const Duration(milliseconds: 150));

      expect(
        callCount,
        10,
        reason: 'Previous action should be cancelled and new action executed',
      );
    });
  });

  group('Throttle Function', () {
    test('Basic Functionality', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final throttledIncrement = throttle(
        incrementCounter,
        const Duration(milliseconds: 100),
      );

      throttledIncrement();

      // Allow some time for the throttled function to execute
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callCount, 1);
    });

    test('Delay Prevention', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final throttledIncrement =
          throttle(incrementCounter, const Duration(milliseconds: 100));

      throttledIncrement();
      // Call again immediately
      throttledIncrement();

      // Allow some time for any throttled functions to potentially execute
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        callCount,
        1,
        reason: 'Function should not be called more than '
            'once within the delay period',
      );
    });

    test('Functionality After Delay', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final throttledIncrement =
          throttle(incrementCounter, const Duration(milliseconds: 100));

      throttledIncrement();
      // Wait for more than the delay period
      await Future.delayed(const Duration(milliseconds: 150));
      // Call again after delay
      throttledIncrement();

      // Allow some time for the throttled function to execute
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        callCount,
        2,
        reason: 'Function should be called again after the delay period',
      );
    });
  });

  group('Throttler Tests', () {
    test('Immediate Invocation', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      Throttler(milliseconds: 100).run(incrementCounter);

      // Allow some time for the action to be executed
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        callCount,
        1,
        reason: 'Action should be executed on the first call',
      );
    });

    test('Throttle Effect', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final throttler = Throttler(milliseconds: 100);

      // ignore: cascade_invocations
      throttler
        ..run(incrementCounter)
        // Try to run again immediately
        ..run(incrementCounter);

      // Wait a bit to see if the second call has any effect
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        callCount,
        1,
        reason: 'Action should not be executed more than '
            'once within the throttle period',
      );
    });

    test('Subsequent Invocation', () async {
      int callCount = 0;
      void incrementCounter() => callCount++;

      final throttler = Throttler(milliseconds: 100);

      // ignore: cascade_invocations
      throttler.run(incrementCounter);

      // Wait for the throttle period to elapse
      await Future.delayed(const Duration(milliseconds: 100));

      // Try to run again
      throttler.run(incrementCounter);

      // Allow some time for the action to be executed
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        callCount,
        2,
        reason: 'Action should be executable again after '
            'the throttle period has elapsed',
      );
    });
  });
}
