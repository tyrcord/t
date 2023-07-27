// Package imports:
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('debugLog', () {
    test('prints message in debug mode', () {
      // Arrange
      const message = 'Test message';

      // Act
      debugLog(message);

      // Assert
      expect(debugPrints(message), true);
    });

    test('adds debug label to message', () {
      // Arrange
      const message = 'Test message';
      const label = 'Test label';

      // Act
      debugLog(message, debugLabel: label);

      // Assert
      expect(debugPrints('[$label]: $message'), true);
    });

    test('adds value to message', () {
      // Arrange
      const message = 'Test message';
      const value = 42;

      // Act
      debugLog(message, value: value);

      // Assert
      expect(debugPrints('$message => $value'), true);
    });

    test('adds debug label and value to message', () {
      // Arrange
      const message = 'Test message';
      const label = 'Test label';
      const value = 42;

      // Act
      debugLog(message, debugLabel: label, value: value);

      // Assert
      expect(debugPrints('[$label]: $message => $value'), true);
    });
  });
}

bool debugPrints(String message) {
  // Capture debug output
  final output = StringBuffer();
  debugPrint = (message, {wrapWidth}) => output.writeln(message);

  // Call debugLog with message
  debugLog(message);

  // Check if message was printed
  return output.toString().contains(message);
}
