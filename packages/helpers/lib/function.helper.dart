//ignore_for_file: no-empty-block
import 'dart:async';
import 'dart:math';

/// A no-operation function that does nothing.
void noop() {}

/// Retries a given asynchronous function [task] for a specified
/// number of [maxAttempts] with an exponential backoff delay.
///
/// [task]: The function to retry if it throws an exception.
/// [maxAttempts]: The maximum number of attempts before throwing an
///                exception. Default is 3.
/// [validate]: A function that checks if the returned value from [task]
///             is valid. If this function returns `false`, the result is
///             considered invalid and the task is retried.
/// [initialDelay]: The initial delay before retrying. This delay is
///                 doubled after every failed attempt. Default is 1 second.
/// [maxDelay]: The maximum delay between retries. If the exponential backoff
///             delay exceeds this value, [maxDelay] is used instead.
///
/// Returns a [Future<T>] representing the result of the function,
/// if successful.
///
/// Throws an [Exception] if [task] fails after [maxAttempts].
Future<T> retry<T>({
  required Future<T> Function() task,
  int maxAttempts = 3,
  bool Function(T result)? validate,
  Duration initialDelay = const Duration(seconds: 1),
  Duration? maxDelay,
}) async {
  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      final T result = await task();

      if (validate == null || validate(result)) {
        return result;
      }

      throw Exception('Validation failed for the result.');
    } catch (e) {
      if (attempt == maxAttempts - 1) {
        rethrow; // if it's the last attempt, rethrow the exception
      }

      /// Calculate delay based on exponential backoff with factor of 2
      final backoffFactor = pow(2, attempt).round();
      Duration delay = Duration(
        milliseconds: (initialDelay.inMilliseconds * backoffFactor),
      );

      /// Ensure the delay does not exceed the specified [maxDelay].
      if (maxDelay != null && delay > maxDelay) {
        delay = maxDelay;
      }

      await Future.delayed(delay); // wait before the next attempt
    }
  }

  throw Exception('Failed after $maxAttempts attempts.');
}
