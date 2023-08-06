// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('isValidUrl', () {
    test('returns true for valid http URL', () {
      expect(isValidUrl('http://example.com'), isTrue);
    });

    test('returns true for valid https URL', () {
      expect(isValidUrl('https://example.com'), isTrue);
    });

    test('returns false for invalid URL', () {
      expect(isValidUrl('example.com'), isFalse);
    });

    test('returns false for non-URL input', () {
      expect(isValidUrl('not a URL'), isFalse);
    });
  });
}
