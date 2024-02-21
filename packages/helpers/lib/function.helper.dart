//ignore_for_file: no-empty-block

// Dart imports:
import 'dart:async';
import 'dart:math';
import 'dart:ui';

/// A no-operation function that does nothing.
void noop() {}

/// Retries a given asynchronous function [task] for a specified
/// number of [maxAttempts] with an exponential backoff delay.
///
/// Parameters:
/// [task]: The function to retry if it throws an exception or doesn't
///         validate.
/// [maxAttempts]: The maximum number of attempts before throwing an
///                exception. Default is 3.
/// [validate]: An optional function that checks if the returned value
///             from [task] is valid. If this function returns `false`,
///             the result is considered invalid and the task is retried.
/// [initialDelay]: The initial delay before retrying. This delay is
///                 doubled after every failed attempt. Default is 1 second.
/// [maxDelay]: The maximum delay between retries. If the exponential backoff
///             delay exceeds this value, [maxDelay] is used instead.
/// [taskTimeout]: The maximum duration to wait for [task] to complete.
///                If the task doesn't complete within this time,
///                a [TimeoutException] is thrown. If not set, the function
///                waits indefinitely for the task.
///
/// Returns:
/// A [Future<T>] representing the result of the function if successful.
///
/// Throws:
/// - [TimeoutException] if [task] doesn't complete within [taskTimeout].
/// - [Exception] if [task] doesn't validate or fails after [maxAttempts].

Future<T> retry<T>({
  required Future<T> Function() task,
  int maxAttempts = 3,
  bool Function(T result)? validate,
  Duration initialDelay = const Duration(seconds: 1),
  Duration? maxDelay,
  Duration? taskTimeout,
}) async {
  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      final T result = taskTimeout == null
          ? await task()
          : await task().timeout(taskTimeout);

      if (validate == null || validate(result)) return result;

      throw Exception('Validation failed for the result.');
    } on TimeoutException {
      if (attempt == maxAttempts - 1) {
        throw TimeoutException(
          'Task timed out after ${taskTimeout!.inSeconds} seconds.',
        );
      }
    } catch (e) {
      // if it's the last attempt, rethrow the exception
      if (attempt == maxAttempts - 1) rethrow;

      /// Calculate delay based on exponential backoff with factor of 2
      final backoffFactor = pow(2, attempt).round();

      Duration delay = Duration(
        milliseconds: (initialDelay.inMilliseconds * backoffFactor),
      );

      /// Ensure the delay does not exceed the specified [maxDelay].
      if (maxDelay != null && delay > maxDelay) delay = maxDelay;

      await Future.delayed(delay); // wait before the next attempt
    }
  }

  throw Exception('Failed after $maxAttempts attempts.');
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

Function debounce(Function func, Duration delay) {
  Timer? timer;

  return () {
    timer?.cancel();
    timer = Timer(delay, () => func());
  };
}

class Throttler {
  final int milliseconds;
  Timer? timer;

  Throttler({required this.milliseconds});

  void run(VoidCallback action) {
    if (timer == null || !timer!.isActive) {
      timer = Timer(Duration(milliseconds: milliseconds), () {
        action();
      });
    }
  }
}

Function throttle(Function func, Duration delay) {
  Timer? timer;

  return () {
    if (timer == null || !timer!.isActive) {
      timer = Timer(delay, () => func());
    }
  };
}
