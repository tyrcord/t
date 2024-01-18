// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/financial_instrument.helper.dart';

void main() {
  group('formatCurrencyPair', () {
    test('should concatenate without delimiter', () {
      expect(
        formatCurrencyPair(base: 'USD', counter: 'EUR'),
        equals('USDEUR'),
      );
    });

    test('should concatenate with delimiter', () {
      expect(
        formatCurrencyPair(
          base: 'USD',
          counter: 'EUR',
          delimiter: '/',
        ),
        equals('USD/EUR'),
      );
    });

    test('should handle empty delimiter as no delimiter', () {
      expect(
        formatCurrencyPair(
          base: 'USD',
          counter: 'EUR',
          delimiter: '',
        ),
        equals('USDEUR'),
      );
    });

    test('should handle null delimiter as no delimiter', () {
      expect(
        formatCurrencyPair(
          base: 'USD',
          counter: 'EUR',
          delimiter: null,
        ),
        equals('USDEUR'),
      );
    });

    test('should work with lower case currency codes', () {
      expect(
        formatCurrencyPair(base: 'usd', counter: 'eur'),
        equals('USDEUR'),
      );
    });
  });
}
