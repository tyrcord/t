import 'package:t_helpers/helpers.dart';

/// Formats a number for clipboard copying. Handles integers and floats,
/// returning a string with appropriate decimal precision.
///
/// [value] is the number to format. Accepts a nullable `num`. If null,
/// returns '0' to signify zero. This ensures output validity.
///
/// Outputs a [String]. Integers are formatted without decimals. Non-integers
/// are formatted with a fixed decimal count, defaulting to two places. This
/// can be adjusted using [maxFractionDigits].
///
/// [maxFractionDigits] is an optional parameter for non-integer numbers. It
/// sets the maximum decimal places, defaulting to 2. It's ignored for integers.
///
/// Returns: String of the formatted number. Integer numbers have no decimals.
/// Non-integers include up to [maxFractionDigits] decimals for consistency.
String formatNumberForClipboard(num? value, {int maxFractionDigits = 2}) {
  // Check if the provided value is null. If it is, default to '0'.
  if (value == null) return '0';

  // Determine if the value is a non-decimal number. If it is, format it
  // without any decimal places. Otherwise, ensure that it has two decimal
  // places to standardize the look of the output.
  return isNumberInteger(value)
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(maxFractionDigits);
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
