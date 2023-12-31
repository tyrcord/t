import 'package:decimal/decimal.dart';

extension DecimalExtension on Decimal {
  double toSafeDouble() {
    double doubleValue = toDouble();

    // Check if the double conversion results in NaN
    if (doubleValue.isNaN) {
      // Convert to string with fixed precision and then to double
      final String fixedPrecision = toStringAsFixed(15);
      doubleValue = double.tryParse(fixedPrecision) ?? double.nan;
    }

    return doubleValue;
  }
}
