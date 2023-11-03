// Package imports:
import 'package:intl/intl.dart';

/// Checks if the input [number] is a "double integer", i.e., a double value
/// that represents an integer value.
/// Returns true if the input [number] is a double integer, false otherwise.
bool isDoubleInteger(double number) => isNumberInteger(number);

/// Checks if the input [number] is an integer.
/// Returns true if the input [number] is an integer, false otherwise.
bool isNumberInteger(num number) {
  final double roundedValue = number.roundToDouble();

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
  if (str.isEmpty) return false;

  if ('%'.allMatches(str).length > 1) return false;

  final lastChar = str[str.length - 1];

  if (lastChar != '%') return false;

  final isNumber = isStringNumber(str.replaceAll('%', ''));

  if (!isNumber) return false;

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
  if (char.isEmpty) return false;

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
  if (char.isEmpty) return false;

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
  if (value == null) return '';

  final (minFractionDigits, maxFractionDigits) = getDefaultFractionDigits(
    value,
    minimumFractionDigits,
    maximumFractionDigits,
  );

  final formatter = NumberFormat(pattern, locale)
    ..maximumFractionDigits = maxFractionDigits
    ..minimumFractionDigits = minFractionDigits;

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
  if (value == null) return '';

  final number = formatDecimal(
    minimumFractionDigits: minimumFractionDigits,
    maximumFractionDigits: maximumFractionDigits,
    value: value * 100,
    pattern: pattern,
    locale: locale,
  );

  return '$number%';
}

/// Formats a [value] as a currency string using the given [locale]and [symbol].
/// [minimumFractionDigits] and [maximumFractionDigits] can be used to specify
/// the minimum and maximum number of decimal places to display.
String formatCurrency({
  num? value,
  String? locale = 'en_US',
  String symbol = 'USD',
  int? minimumFractionDigits,
  int? maximumFractionDigits,
}) {
  if (value == null) return '';

  final (minFractionDigits, maxFractionDigits) = getDefaultFractionDigits(
    value,
    minimumFractionDigits,
    maximumFractionDigits,
  );

  symbol = symbol.toUpperCase();

  final formatter = NumberFormat.simpleCurrency(locale: locale, name: symbol)
    ..maximumFractionDigits = maxFractionDigits
    ..minimumFractionDigits = minFractionDigits;

  return formatter.format(value);
}

/// Retrieves the default minimum and maximum fraction digits based on
/// the provided [value].
///
/// The [value] parameter is used to determine the default fraction digits.
/// If [value] is of type [double], the method checks if it is an integer.
/// If it is an integer, the default fraction digits are set to 0. Otherwise,
/// the default fraction digits are set to 2. If [value] is not of type
/// [double], the default fraction digits are set to 0.
///
/// The [minimumFractionDigits] and [maximumFractionDigits] parameters allow
/// overriding the default values for minimum and maximum fraction digits,
/// respectively. If these parameters are not provided, the default values
/// determined based on the [value] type will be used.
/// If [maximumFractionDigits] is less than [minimumFractionDigits], it
/// will be adjusted to equal [minimumFractionDigits].
///
/// The method returns a tuple of two integers representing the default minimum
/// and maximum fraction digits.
(int minimumFractionDigits, int maximumFractionDigits) getDefaultFractionDigits(
  num? value,
  int? minimumFractionDigits,
  int? maximumFractionDigits,
) {
  if (value is double) {
    // Check if the value is an integer
    final isInt = isDoubleInteger(value);

    if (isInt) {
      // If the value is an integer, set the fraction digits to 0
      minimumFractionDigits ??= 0;
      maximumFractionDigits ??= 0;
    } else {
      // If the value is not an integer, set the default fraction digits to 2
      minimumFractionDigits ??= 2;
      maximumFractionDigits ??= minimumFractionDigits;
    }
  } else {
    // If the value is not a double, set the fraction digits to 0
    minimumFractionDigits ??= 0;
    maximumFractionDigits ??= 0;
  }

  // Ensure that maximumFractionDigits is not less than minimumFractionDigits
  if (maximumFractionDigits < minimumFractionDigits) {
    minimumFractionDigits = maximumFractionDigits;
  }

  // Return the default fraction digits as a tuple
  return (minimumFractionDigits, maximumFractionDigits);
}
