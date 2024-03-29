// ignore_for_file: lines_longer_than_80_chars

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('isDoubleInteger', () {
    test('Test case 1: Input is a double integer', () {
      const double x = 5.0;
      expect(isDoubleInteger(x), true);
    });

    test('Test case 2: Input is not a double integer', () {
      const double y = 2.5;
      expect(isDoubleInteger(y), false);
    });

    test('Test case 3: Input is a negative double integer', () {
      const double z = -10.0;
      expect(isDoubleInteger(z), true);
    });

    test(
        'Test case 4: Input is a small double value that is not a double integer',
        () {
      const double a = 0.000001;
      expect(isDoubleInteger(a), false);
    });

    test(
        'Test case 5: Input is a large double value that is not a double integer',
        () {
      const double b = 100000000.123;
      expect(isDoubleInteger(b), false);
    });

    test('Test case 6: Input is a double integer with epsilon exponent', () {
      const double c1 = 99999.99999999769;
      const double c2 = 10.0;
      const double c3 = 10.5;

      expect(isDoubleInteger(c1, epsilonExponent: 10), false);
      expect(isDoubleInteger(c1, epsilonExponent: 6), true);
      expect(isDoubleInteger(c2, epsilonExponent: 6), true);
      expect(isDoubleInteger(c3, epsilonExponent: 1), false);
      expect(isDoubleInteger(c3, epsilonExponent: 0), true);
    });
  });

  group('isStringNumber', () {
    test('Returns true for valid numbers', () {
      expect(isStringNumber('123'), isTrue);
      expect(isStringNumber('123.45'), isTrue);
      expect(isStringNumber('-123.45'), isTrue);
      expect(isStringNumber('0'), isTrue);
    });

    test('Returns false for invalid numbers', () {
      expect(isStringNumber(''), isFalse);
      expect(isStringNumber('abc'), isFalse);
      expect(isStringNumber('123abc'), isFalse);
    });
  });

  group('formatDecimal', () {
    test('formats integer value with default options', () {
      expect(formatDecimal(value: 1234), equals('1,234'));
    });

    test('formats decimal value with default options', () {
      expect(formatDecimal(value: 1234.567), equals('1,234.57'));
      expect(formatDecimal(value: 1234.5), equals('1,234.50'));
      expect(formatDecimal(value: 1234.00), equals('1,234'));
    });

    test('formats decimal value with custom pattern', () {
      expect(
        formatDecimal(
          value: 1234.567,
          pattern: "#,##0.000",
          maximumFractionDigits: 3,
        ),
        equals('1,234.567'),
      );
    });

    test('formats decimal value with custom locale', () {
      expect(
        formatDecimal(value: 1234.567, locale: 'fr_FR'),
        equals('1 234,57'),
      );

      expect(
        formatDecimal(value: 1234567.890123, locale: 'de_DE'),
        equals('1.234.567,89'),
      );
    });

    test('formats decimal value with custom minimum fraction digits', () {
      expect(
        formatDecimal(value: 1234.5, minimumFractionDigits: 2),
        equals('1,234.50'),
      );
    });

    test('formats decimal value with custom maximum fraction digits', () {
      expect(
        formatDecimal(value: 1234.56789, maximumFractionDigits: 4),
        equals('1,234.5679'),
      );
    });

    test('returns empty string when value is null', () {
      expect(formatDecimal(value: null), equals(''));
    });
  });

  group('formatPercentage', () {
    test('formats percentage with default options', () {
      expect(formatPercentage(value: 0.5), equals('50%'));
      expect(formatPercentage(value: 0.01), equals('1%'));
      expect(formatPercentage(value: 0.011), equals('1.10%'));
      expect(formatPercentage(value: 0.01256), equals('1.26%'));
    });

    test('formats percentage with custom options', () {
      expect(
        formatPercentage(
          value: 0.1234,
          locale: 'fr_FR',
          minimumFractionDigits: 2,
          maximumFractionDigits: 4,
        ),
        equals('12,34%'),
      );
    });

    test('returns empty string when value is null', () {
      expect(formatPercentage(value: null), equals(''));
    });
  });

  group('formatCurrency', () {
    test('formats positive value with default parameters', () {
      expect(formatCurrency(value: 1234.56), equals('\$1,234.56'));
      expect(formatCurrency(value: 1), equals('\$1'));
      expect(formatCurrency(value: 1.1), equals('\$1.10'));
    });

    test('formats negative value with default parameters', () {
      expect(formatCurrency(value: -1234.56), equals('-\$1,234.56'));
      expect(formatCurrency(value: -1), equals('-\$1'));
      expect(formatCurrency(value: -1.1), equals('-\$1.10'));
    });

    test('formats zero value with default parameters', () {
      expect(formatCurrency(value: 0), equals('\$0'));
      expect(formatCurrency(value: 0.1), equals('\$0.10'));
      expect(formatCurrency(value: 0.123), equals('\$0.12'));
    });

    test('formats value with custom locale', () {
      expect(
        formatCurrency(value: 1234.56, locale: 'de_DE'),
        equals('1.234,56 \$'),
      );

      expect(
        formatCurrency(value: 1234.56, locale: 'de_de'),
        equals('1.234,56 \$'),
      );
    });

    test('formats value with custom symbol', () {
      expect(
        formatCurrency(value: 1234.56, symbol: 'EUR'),
        equals('€1,234.56'),
      );
    });

    test('formats value with lowercase custom symbol', () {
      expect(
        formatCurrency(value: 1234.56, symbol: 'eur'),
        equals('€1,234.56'),
      );
    });

    test('formats value with custom minimum fraction digits', () {
      expect(
        formatCurrency(value: 1234.5678, minimumFractionDigits: 3),
        equals('\$1,234.568'),
      );
      expect(
        formatCurrency(value: 1234.5, minimumFractionDigits: 2),
        equals('\$1,234.50'),
      );
      expect(
        formatCurrency(value: 1234.5, minimumFractionDigits: 1),
        equals('\$1,234.5'),
      );
    });

    test('formats value with custom maximum fraction digits', () {
      expect(
        formatCurrency(value: 1234.5678, maximumFractionDigits: 3),
        equals('\$1,234.568'),
      );
      expect(
        formatCurrency(value: 1234.5678, maximumFractionDigits: 0),
        equals('\$1,235'),
      );
    });

    test('returns empty string for null value', () {
      expect(formatCurrency(value: null), equals(''));
    });
  });

  group('isCharDigit', () {
    test(' returns true for digits', () {
      expect(isCharDigit('0'), true);
      expect(isCharDigit('1'), true);
      expect(isCharDigit('2'), true);
      expect(isCharDigit('3'), true);
      expect(isCharDigit('4'), true);
      expect(isCharDigit('5'), true);
      expect(isCharDigit('6'), true);
      expect(isCharDigit('7'), true);
      expect(isCharDigit('8'), true);
      expect(isCharDigit('9'), true);
    });

    test('returns false for non-digits', () {
      expect(isCharDigit('a'), false);
      expect(isCharDigit(' '), false);
      expect(isCharDigit('+'), false);
      expect(isCharDigit('*'), false);
      expect(isCharDigit('/'), false);
    });

    test('returns false for empty string', () {
      expect(isCharDigit(''), false);
    });
  });

  group('isCharDigitOrDecimalPoint', () {
    test(' returns true for digits', () {
      expect(isCharDigitOrDecimalPoint('0'), true);
      expect(isCharDigitOrDecimalPoint('1'), true);
      expect(isCharDigitOrDecimalPoint('2'), true);
      expect(isCharDigitOrDecimalPoint('3'), true);
      expect(isCharDigitOrDecimalPoint('4'), true);
      expect(isCharDigitOrDecimalPoint('5'), true);
      expect(isCharDigitOrDecimalPoint('6'), true);
      expect(isCharDigitOrDecimalPoint('7'), true);
      expect(isCharDigitOrDecimalPoint('8'), true);
      expect(isCharDigitOrDecimalPoint('9'), true);
    });

    test('returns false for non-digits', () {
      expect(isCharDigitOrDecimalPoint('a'), false);
      expect(isCharDigitOrDecimalPoint(' '), false);
      expect(isCharDigitOrDecimalPoint('+'), false);
      expect(isCharDigitOrDecimalPoint('*'), false);
      expect(isCharDigitOrDecimalPoint('/'), false);
    });

    test('returns false for empty string', () {
      expect(isCharDigitOrDecimalPoint(''), false);
    });

    test('Returns true for decimal point', () {
      expect(isCharDigitOrDecimalPoint('.'), isTrue);
    });
  });

  group('isStringPercentage', () {
    test('returns true for strings ending with %', () {
      expect(isStringPercentage('50%'), isTrue);
      expect(isStringPercentage('0.5%'), isTrue);
      expect(isStringPercentage('100%'), isTrue);
      expect(isStringPercentage('50.0%'), isTrue);
      expect(isStringPercentage('50 %'), isTrue);
    });

    test('returns false for strings not ending with %', () {
      expect(isStringPercentage('50'), isFalse);
      expect(isStringPercentage('0.5'), isFalse);
      expect(isStringPercentage('100'), isFalse);
      expect(isStringPercentage('50%%'), isFalse);
    });
  });
}
