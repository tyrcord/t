// Package imports:
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rational/rational.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('decimalFromDouble', () {
    test('should return null for NaN', () {
      expect(decimalFromDouble(double.nan), isNull);
    });

    test('should return null for infinity', () {
      expect(decimalFromDouble(double.infinity), isNull);
    });

    test('should return null for negative infinity', () {
      expect(decimalFromDouble(double.negativeInfinity), isNull);
    });

    test('should return a Decimal for a finite double', () {
      expect(decimalFromDouble(3.14), equals(Decimal.parse('3.14')));
    });
  });

  group('decimalFromNumber', () {
    test('should return a Decimal for an int', () {
      expect(decimalFromNumber(42), equals(Decimal.fromInt(42)));
    });

    test('should return a Decimal for a double', () {
      expect(decimalFromNumber(3.14), equals(Decimal.parse('3.14')));
    });
  });

  group('decimalFromRational', () {
    test('should return a Decimal for a Rational', () {
      expect(decimalFromRational(Rational.fromInt(1, 3)),
          equals(Decimal.parse('0.33333333333333333333333333333333')));
    });
  });

  group('toDecimal', () {
    test('should return a Decimal for an int', () {
      expect(toDecimal(42), equals(Decimal.fromInt(42)));
    });

    test('should return a Decimal for a double', () {
      expect(toDecimal(3.14), equals(Decimal.parse('3.14')));
    });

    test('should return a Decimal for a Rational', () {
      expect(toDecimal(Rational.fromInt(1, 3)),
          equals(Decimal.parse('0.33333333333333333333333333333333')));
    });

    test('should return a Decimal for a String', () {
      expect(toDecimal('3.14'), equals(Decimal.parse('3.14')));
    });

    test('should return null for an invalid String', () {
      expect(toDecimal('foo'), isNull);
    });
  });
}
