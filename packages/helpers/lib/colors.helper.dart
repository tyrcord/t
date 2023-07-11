// Flutter imports:
import 'package:flutter/widgets.dart';

/// Lightens a given color by a certain amount using the HSL color model.
///
/// The `color` parameter specifies the color to be lightened. The `amount`
/// parameter specifies the amount of lightness to be applied to the color,
/// where `0` means no lightness (i.e., the original color), and `1` means
/// complete lightness (i.e., white). The `amount` parameter must be a value
/// between `0` and `1`.
///
/// Returns the lightened color as a `Color` object.
Color lightenColor(Color color, double amount) {
  // Make sure the amount is within the expected range
  assert(amount >= 0 && amount <= 1);

  // Convert the color to an HSLColor object
  final hslColor = HSLColor.fromColor(color);

  // Calculate the new lightness value by adding the amount to the current
  // lightness value
  final lightness = hslColor.lightness + amount;

  // Create a new HSLColor object with the new lightness value, clamped to a
  // range of 0.0 to 1.0
  final hslLight = hslColor.withLightness((lightness).clamp(0.0, 1.0));

  // Convert the new HSLColor back to a Color object and return it
  return hslLight.toColor();
}

/// Darkens a given color by a certain amount using the HSL color model.
///
/// The `color` parameter specifies the color to be darkened. The `amount`
/// parameter specifies the amount of darkness to be applied to the color, where
/// `0` means no darkness (i.e., the original color), and `1` means complete
/// darkness (i.e., black). The `amount` parameter must be a value between `0`
/// and `1`.
///
/// Returns the darkened color as a `Color` object.
Color darkenColor(Color color, double amount) {
  // Make sure the amount is within the expected range
  assert(amount >= 0 && amount <= 1);

  // Convert the color to an HSLColor object
  final hslColor = HSLColor.fromColor(color);

  // Calculate the new lightness value by subtracting the amount from the
  // current lightness value
  final lightness = hslColor.lightness - amount;

  // Create a new HSLColor object with the new lightness value, clamped to a
  // range of 0.0 to 1.0
  final hslDark = hslColor.withLightness((lightness).clamp(0.0, 1.0));

  // Convert the new HSLColor back to a Color object and return it
  return hslDark.toColor();
}
