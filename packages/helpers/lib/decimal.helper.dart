// Package imports:
import 'package:decimal/decimal.dart';
import 'package:rational/rational.dart';

/// Decimal zero.
final dZero = Decimal.fromInt(0);

/// Decimal one.
final dOne = Decimal.fromInt(1);

/// Decimal two.
final dTwo = Decimal.fromInt(2);

/// Decimal three.
final dThree = Decimal.fromInt(3);

/// Decimal four.
final dFour = Decimal.fromInt(4);

/// Decimal five.
final dFive = Decimal.fromInt(5);

/// Decimal one hundred.
final dHundred = Decimal.fromInt(100);

/// Converts a double [value] to a [Decimal] if possible.
///
/// Returns `null` if the conversion fails.
Decimal? decimalFromDouble(double value) => Decimal.tryParse(value.toString());

/// Converts a [num] [value] to a [Decimal].
///
/// If [value] is an [int], it is converted to a [Decimal] using
/// [Decimal.fromInt].
/// Otherwise, [value] is converted to a [double] and then to a [Decimal].
Decimal decimalFromNumber(num value) {
  if (value is int) {
    return Decimal.fromInt(value);
  }

  return decimalFromDouble(value as double)!;
}

/// Converts a [Rational] [value] to a [Decimal].
///
/// The [value] is converted to a [Decimal] using [Rational.toDecimal].
/// The [scaleOnInfinitePrecision] parameter is set to 32.
Decimal decimalFromRational(Rational value) {
  return value.toDecimal(scaleOnInfinitePrecision: 32);
}

/// Returns a [Decimal] representation of the given [value].
///
/// If [value] is an [int], returns a [Decimal] with the same value as [value].
///
/// If [value] is a [double], returns a [Decimal] with the same value
/// as [value],
/// or `null` if the conversion fails.
///
/// If [value] is a [Rational], returns a [Decimal] with the same value
/// as [value].
///
/// If [value] is a [String], attempts to parse it as a [Decimal] and returns
/// the result, or `null` if the parsing fails.
///
/// Throws an [AssertionError] if [value] is not a [num], [Rational],
/// or [String].
Decimal? toDecimal(dynamic value) {
  if (value is Decimal) {
    return value;
  } else if (value is num) {
    return decimalFromNumber(value);
  } else if (value is Rational) {
    return decimalFromRational(value);
  } else if (value is String) {
    if (value.isNotEmpty) {
      return Decimal.tryParse(value);
    }
  }

  return null;
}

Decimal toDecimalOrDefault(dynamic value) => toDecimal(value) ?? dZero;
