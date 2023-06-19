import 'package:intl/intl.dart';
import 'package:t_helpers/helpers.dart';

/// Checks if the input [number] is a "double integer", i.e., a double value
/// that represents an integer value.
/// Returns true if the input [number] is a double integer, false otherwise.
bool isDoubleInteger(double number) {
  double roundedValue = number.roundToDouble();

  return number == roundedValue;
}

/// Returns `true` if [str] represents a valid number, `false` otherwise.
///
/// This function attempts to parse the input string as a double using
/// the [double.tryParse] method. If the conversion succeeds, the function
/// returns `true`. Otherwise, it returns `false`.
bool isStringNumber(String str) {
  final doubleValue = double.tryParse(str);

  return doubleValue != null;
}

/// Returns true if the given [str] is a string representation of a percentage,
/// false otherwise.
///
/// A string is considered a percentage if it:
///   - is not empty
///   - contains at most one '%' character
///   - ends with a '%' character
///   - the remaining characters, after removing the '%' character, represent
///     a valid number.
bool isStringPercentage(String str) {
  if (str.isEmpty) {
    return false;
  }

  if ('%'.allMatches(str).length > 1) {
    return false;
  }

  final lastChar = str[str.length - 1];

  if (lastChar != '%') {
    return false;
  }

  var isNumber = isStringNumber(str.replaceAll('%', ''));

  if (!isNumber) {
    return false;
  }

  return true;
}

/// Returns `true` if [char] represents a digit, `false` otherwise.
///
/// This function checks whether the input string is not empty and whether
/// its first character is a digit (i.e., has a Unicode code point between
/// the code points of '0' and '9').
///
/// If the input string satisfies this condition, the function returns `true`.
/// Otherwise, it returns `false`.
bool isCharDigit(String char) {
  if (char.isEmpty) {
    return false;
  }

  final firstCodePoint = char.codeUnitAt(0);

  return (firstCodePoint >= '0'.codeUnitAt(0)) &&
      (firstCodePoint <= '9'.codeUnitAt(0));
}

/// Returns `true` if [char] represents a digit or a decimal point,
/// `false` otherwise.
///
/// This function checks whether the input string is not empty and whether
/// its first character is a digit (i.e., has a Unicode code point between
/// the code points of '0' and '9') or a decimal point ('.').
///
/// If the input string satisfies either of these conditions, the function
/// returns `true`. Otherwise, it returns `false`.
bool isCharDigitOrDecimalPoint(String char) {
  if (char.isEmpty) {
    return false;
  }

  final isDecimalPoint = char == '.';

  return isCharDigit(char) || isDecimalPoint;
}

/// Formats a [value] as a decimal string using the given [locale] and
/// [pattern].
/// [minimumFractionDigits] and [maximumFractionDigits] can be used to specify
/// the minimum and maximum number of decimal places to display.
String formatDecimal({
  num? value,
  String? locale = 'en_US',
  String? pattern = "#,##0.##",
  int? minimumFractionDigits,
  int? maximumFractionDigits,
}) {
  if (value == null) {
    return '';
  }

  final (minFractionDigits, maxFractionDigits) = getDefaultFractionDigits(
    value,
    minimumFractionDigits,
    maximumFractionDigits,
  );

  final formatter = NumberFormat(pattern, locale);
  formatter.maximumFractionDigits = maxFractionDigits;
  formatter.minimumFractionDigits = minFractionDigits;

  return formatter.format(value);
}

/// Formats a [value] as a percentage string using the given [locale] and
/// [pattern]. [minimumFractionDigits] and [maximumFractionDigits] can be used
/// to specify the minimum and maximum number of decimal places to display.
String formatPercentage({
  num? value,
  String? locale = 'en_US',
  String? pattern = "#,##0.##",
  int? minimumFractionDigits,
  int? maximumFractionDigits,
}) {
  if (value == null) {
    return '';
  }

  final number = formatDecimal(
    minimumFractionDigits: minimumFractionDigits,
    maximumFractionDigits: maximumFractionDigits,
    value: value * 100,
    locale: locale,
  );

  return '$number%';
}

/// Formats a [value] as a currency string using the given [locale], [pattern],
/// and [symbol]. [minimumFractionDigits] and [maximumFractionDigits] can be
/// used to specify the minimum and maximum number of decimal places to display.
String formatCurrency({
  num? value,
  String? locale = 'en_US',
  String? pattern = "#,##0.##",
  String symbol = 'USD',
  int? minimumFractionDigits,
  int? maximumFractionDigits,
}) {
  if (value == null) {
    return '';
  }

  final (minFractionDigits, maxFractionDigits) = getDefaultFractionDigits(
    value,
    minimumFractionDigits,
    maximumFractionDigits,
  );

  final formatter = NumberFormat.simpleCurrency(locale: locale, name: symbol);
  formatter.maximumFractionDigits = maxFractionDigits;
  formatter.minimumFractionDigits = minFractionDigits;

  return formatter.format(value);
}

double calculatePercentageDecrease(double originalValue, double newValue) {
  final dOriginalValue = toDecimal(originalValue)!;
  final dNewValue = toDecimal(newValue)!;

  final dDecrease = dOriginalValue - dNewValue;
  final percentageDecrease = decimalFromRational(dDecrease / dOriginalValue);

  return percentageDecrease.toDouble();
}

(int minimumFractionDigits, int maximumFractionDigits) getDefaultFractionDigits(
  num? value,
  int? minimumFractionDigits,
  int? maximumFractionDigits,
) {
  if (value is double) {
    final isInt = isDoubleInteger(value);

    if (isInt) {
      minimumFractionDigits ??= 0;
      maximumFractionDigits ??= 0;
    } else {
      minimumFractionDigits ??= 2;
      maximumFractionDigits ??= 2;
    }
  } else {
    minimumFractionDigits ??= 0;
    maximumFractionDigits ??= 0;
  }

  if (maximumFractionDigits < minimumFractionDigits) {
    minimumFractionDigits = maximumFractionDigits;
  }

  return (minimumFractionDigits, maximumFractionDigits);
}
