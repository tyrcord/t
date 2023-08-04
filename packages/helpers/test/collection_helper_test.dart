// ignore_for_file: lines_longer_than_80_chars

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('transformTo2DArray', () {
    test('should return an empty list when given an empty list', () {
      expect(transformTo2DArray([], 2), equals([]));
    });

    test(
      'should return a 2D array with one row when given '
      'an array with length less than columns',
      () {
        expect(
          transformTo2DArray([1, 2, 3], 4),
          equals([
            [1, 2, 3]
          ]),
        );
      },
    );

    test('should return a 2D array with one column when given columns = 1', () {
      expect(
          transformTo2DArray([1, 2, 3], 1),
          equals([
            [1],
            [2],
            [3]
          ]));
    });

    test('should return a 2D array with correct number of rows and columns',
        () {
      expect(
          transformTo2DArray([1, 2, 3, 4, 5, 6], 3),
          equals([
            [1, 2, 3],
            [4, 5, 6]
          ]));
    });

    test(
        'should return a 2D array with correct number of rows '
        'and columns when given an array with length not divisible by columns',
        () {
      expect(
          transformTo2DArray([1, 2, 3, 4, 5], 3),
          equals([
            [1, 2, 3],
            [4, 5]
          ]));
    });
  });

  group('getRandomItem', () {
    test('returns null for empty list', () {
      expect(getRandomItem([]), isNull);
    });

    test('returns single item for list with one item', () {
      final list = ['a'];
      expect(getRandomItem(list), equals('a'));
    });
  });
}
