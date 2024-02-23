// ignore_for_file: lines_longer_than_80_chars

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
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

  group('rangeAroundN', () {
    test('Standard case', () {
      expect(rangeAroundN(5, 3), equals([2, 3, 4, 5, 6, 7, 8]));
    });

    test('n at the edge of 0', () {
      expect(rangeAroundN(1, 3), equals([1, 2, 3, 4]));
    });

    test('n less than x, start should be 1', () {
      expect(rangeAroundN(2, 3), equals([1, 2, 3, 4, 5]));
    });

    test('Zero range around n', () {
      expect(rangeAroundN(5, 0), equals([5]));
    });

    test('n is 0, should start from 1', () {
      expect(rangeAroundN(0, 3), equals([1, 2, 3]));
    });

    test('Negative n, treated as 0, should start from 1', () {
      expect(rangeAroundN(-2, 3), equals([1]));
    });

    test('Large range', () {
      expect(rangeAroundN(10, 10), equals(List.generate(20, (i) => i + 1)));
    });

    test('with loose true', () {
      expect(rangeAroundN(5.0, 2, loose: true), [3, 4, 5.0, 6, 7]);
      expect(rangeAroundN(5.5, 3, loose: true), [2, 3, 4, 5.5, 6, 7, 8]);
      expect(
        rangeAroundN(5.5, 3, loose: false),
        [2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5],
      );
    });
  });
}
