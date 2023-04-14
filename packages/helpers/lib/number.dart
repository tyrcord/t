import 'package:intl/intl.dart';

/// Checks if the input [number] is a "double integer", i.e., a double value
/// that represents an integer value.
/// Returns true if the input [number] is a double integer, false otherwise.
bool isDoubleInteger(double number) {
  double roundedValue = number.roundToDouble();

  return number == roundedValue;
}

/// Returns `true` if [str] represents a valid number, `false` otherwise.
///
/// This function attempts to parse the input string as a double using the [double.tryParse] method. If the conversion succeeds, the function returns `true`. Otherwise, it returns `false`.
bool isStringNumber(String str) {
  final doubleValue = double.tryParse(str);

  return doubleValue != null;
}

/// Formats a [num] value as a string with the specified [locale] and [pattern].
///
/// The [locale] argument is optional and defaults to `'en_US'`, which is the locale for the United States.
///
/// The [pattern] argument is optional and defaults to `'#,##0.######'`, which formats the number with commas for the thousands separator and a period for the decimal separator, and includes up to six decimal places.
///
/// Returns the formatted number as a [String].
String formatDecimal(
  num value, {
  String locale = 'en_US',
  String pattern = "#,##0.######",
}) {
  final formatter = NumberFormat(pattern, locale);

  return formatter.format(value);
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
