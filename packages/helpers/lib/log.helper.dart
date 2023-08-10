// Flutter imports:
import 'package:flutter/foundation.dart';

/// Function that prints a debug message to the console if the app is running
/// in debug mode.
///
/// This function takes a [message] as the main content of the debug log. It
/// also accepts an optional [debugLabel], which can be used to provide a label
/// for the log message. If a [value] is provided, it will be appended to the
/// message, separated by " => ".
///
/// Example:
/// ```dart
/// debugLog('Hello, world!', debugLabel: 'Greeting', value: 42);
/// // Output: "[Greeting]: Hello, world! => 42"
/// ```
void debugLog(String message, {String? debugLabel, dynamic value}) {
  // Check if the app is running in debug mode
  if (kDebugMode) {
    // Append the debug label to the message if provided
    if (debugLabel != null) {
      message = '[$debugLabel]: $message';
    }

    // Append the value to the message if provided
    if (value != null) {
      message = '$message => $value';
    }

    // Print the final message to the console
    debugPrint(message);
  }
}
