// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('isDoubleInteger', () {
    test('Test case 1: Input is a double integer', () {
      double x = 5.0;
      expect(isDoubleInteger(x), true);
    });

    test('Test case 2: Input is not a double integer', () {
      double y = 2.5;
      expect(isDoubleInteger(y), false);
    });

    test('Test case 3: Input is a negative double integer', () {
      double z = -10.0;
      expect(isDoubleInteger(z), true);
    });

    test(
        'Test case 4: Input is a small double value that is not a double integer',
        () {
      double a = 0.000001;
      expect(isDoubleInteger(a), false);
    });

    test(
        'Test case 5: Input is a large double value that is not a double integer',
        () {
      double b = 100000000.123;
      expect(isDoubleInteger(b), false);
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
    test('Formats a number with default locale and pattern', () {
      expect(formatDecimal(1234567.890123), equals('1,234,567.890123'));
    });

    test('Formats a number with a custom locale', () {
      expect(
        formatDecimal(1234567.890123, locale: 'de_DE'),
        equals('1.234.567,890123'),
      );
    });

    test('Formats a number with a custom pattern', () {
      expect(
        formatDecimal(1234567.890123, pattern: '#,###.##'),
        equals('1,234,567.89'),
      );
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
