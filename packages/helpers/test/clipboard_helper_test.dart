// ignore_for_file: lines_longer_than_80_chars

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('formatNumberForClipboard', () {
    test('should return "0" if the value is null', () {
      final result = formatNumberForClipboard(null);
      expect(result, '0');
    });

    test('should return integer value without decimal points', () {
      final result = formatNumberForClipboard(10.0);
      expect(result, '10');
    });

    test('should format non-integer double with two decimal places', () {
      final result = formatNumberForClipboard(10.123);
      expect(result, '10.12'); // it should round the value
    });

    test('should return negative value formatted appropriately', () {
      final result = formatNumberForClipboard(-15.457);
      expect(result, '-15.46'); // it should handle and round negative values
    });

    test('Correctly formats non-integer with 1 decimal place', () {
      expect(formatNumberForClipboard(123.456, maxFractionDigits: 1),
          equals('123.5'));
    });

    test('Correctly formats non-integer with 3 decimal places', () {
      expect(formatNumberForClipboard(123.4567, maxFractionDigits: 3),
          equals('123.457'));
    });

    test('Correctly formats integer regardless of maxFractionDigits', () {
      expect(
          formatNumberForClipboard(123, maxFractionDigits: 3), equals('123'));
    });
  });

  group('formatPercentageForClipboard', () {
    test('should return a percentage string with non-null input', () {
      expect(formatPercentageForClipboard(0.25), '25%');
      expect(formatPercentageForClipboard(1), '100%');
    });

    test('should handle edge cases', () {
      expect(formatPercentageForClipboard(0), '0%');
      expect(formatPercentageForClipboard(-0.25), '-25%');
    });

    test('should handle large numbers', () {
      expect(formatPercentageForClipboard(1000), '100000%');
    });

    test('should handle null input', () {
      expect(formatPercentageForClipboard(null), '0%');
    });
  });
}
