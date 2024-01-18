// Package imports:
import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';
import 'package:t_helpers/helpers.dart';

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

extension RationExtension on Rational {
  double toSafeDouble() {
    return decimalFromRational(this).toSafeDouble();
  }
}
