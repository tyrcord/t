import 'package:t_helpers/helpers.dart';

/// This function is responsible for formatting a number value into a string
/// that's suitable for clipboard copy operations. It handles scenarios where
/// the value is either an integer or a non-integer and ensures appropriate
/// decimal placement in the string representation.
///
/// [value] (num?) is the number intended for formatting. If the value is
/// null, a default string '0' is returned to represent a zero value.
///
/// Returns a [String] that represents the formatted value of the input number.
/// If the number is an integer, no decimals are included. Otherwise, the
/// number is formatted to have two decimal places.
String formatNumberForClipboard(num? value) {
  // Check if the provided value is null. If it is, default to '0'.
  if (value == null) return '0';

  // Determine if the value is a non-decimal number. If it is, format it
  // without any decimal places. Otherwise, ensure that it has two decimal
  // places to standardize the look of the output.
  return isNumberInteger(value)
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
}

/// Formats a numeric value into a percentage string suitable for clipboard
/// operations.
///
/// This function takes a [num] value (which could be `null`) and returns it
/// as a formatted string appended with a percentage sign. The formatting
/// applied is based on the `formatNumberForClipboard` function, which is
/// presumed to be defined elsewhere within the scope of this application.
///
/// Example usage:
/// ```
/// var percentage = formatPercentageForClipboard(0.45);
/// print(percentage); // Output: '45%'
/// ```
///
/// - Parameter [value]: The numeric value to be formatted. Can be `null`.
/// - Returns: A [String] representing the formatted percentage. If the value is
/// null, a default string '0%' is returned to represent a zero value.
String formatPercentageForClipboard(num? value) {
  final rate = (value ?? 0) * 100;
  final formattedRate = formatNumberForClipboard(rate);

  return '$formattedRate%';
}
