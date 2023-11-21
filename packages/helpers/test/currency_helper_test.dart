import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('getCurrencySymbol Tests', () {
    test('Should return \$ for USD', () {
      expect(getCurrencySymbol(currencyCode: 'USD'), equals('\$'));
    });

    test('Should return € for EUR', () {
      expect(getCurrencySymbol(currencyCode: 'EUR'), equals('€'));
    });

    test('Should return default \$ when no currency code is provided', () {
      expect(getCurrencySymbol(), equals('\$'));
    });

    test('Should handle null localeCode gracefully', () {
      expect(
        getCurrencySymbol(localeCode: null, currencyCode: 'EUR'),
        equals('€'),
      );
    });

    test('Edge Case: Should handle long strings', () {
      expect(
        getCurrencySymbol(currencyCode: 'THISISALONGSTRING'),
        equals('THISISALONGSTRING'),
      );
    });
  });
}
