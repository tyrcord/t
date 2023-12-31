import 'package:t_helpers/helpers.dart';
import 'package:tenhance/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';

void main() {
  group('Decimal toSafeDouble Tests', () {
    test('Normal Conversion', () {
      final Decimal decimalValue = Decimal.parse('123.456');
      final double result = decimalValue.toSafeDouble();

      expect(result, equals(123.456));
    });

    test('Conversion of Large Number', () {
      final Decimal largeValue = Decimal.parse('1e50'); // A very large number
      final double result = largeValue.toSafeDouble();

      expect(result.isNaN, isFalse); // Should not be NaN
    });

    test('Conversion of Small Number', () {
      final Decimal smallValue = Decimal.parse('1e-50'); // A very small number

      // Should not be NaN
      expect(smallValue.toSafeDouble().isNaN, isFalse);

      // Should not be NaN
      expect(smallValue.toDouble().isNaN, isFalse);

      final dPrincipal = toDecimalOrDefault(10000);
      final dRate = toDecimalOrDefault(0.001);
      const compoundPeriods = 365;
      final dResult =
          dPrincipal * toDecimalOrDefault((dOne + dRate).pow(compoundPeriods));

      expect(dResult.toSafeDouble(), closeTo(14402.51, 0.01));
      expect(dResult.toDouble().isNaN, isTrue);
    });
  });
}
