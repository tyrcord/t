// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('calculatePercentageDecrease', () {
    test('returns 0% when originalValue and newValue are equal', () {
      expect(calculatePercentageDecrease(10, 10), equals(0.0));
    });

    test('returns 50% when originalValue is twice the newValue', () {
      expect(calculatePercentageDecrease(10, 5), equals(0.50));
    });

    test('returns 66.66% when originalValue is 3 times the newValue', () {
      expect(calculatePercentageDecrease(15, 5), closeTo(0.66, 0.01));
    });

    test('returns 100% when newValue is 0', () {
      expect(calculatePercentageDecrease(10, 0), equals(1.0));
    });

    test('returns -100% when newValue is twice the originalValue', () {
      expect(calculatePercentageDecrease(5, 10), equals(-1));
    });

    test('returns -200% when newValue is 3 times the originalValue', () {
      expect(calculatePercentageDecrease(5, 15), equals(-2));
    });
  });
}
