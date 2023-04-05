import 'package:flutter/widgets.dart';

// Function to lighten a given color by a certain amount (using HSL color model)
Color lightenColor(Color color, double amount) {
  // Make sure the amount is within the expected range
  assert(amount >= 0 && amount <= 1);

  // Convert the color to an HSLColor object
  final hslColor = HSLColor.fromColor(color);

  // Calculate the new lightness value by adding the amount to the current lightness value
  final lightness = hslColor.lightness + amount;

  // Create a new HSLColor object with the new lightness value, clamped to a range of 0.0 to 1.0
  final hslLight = hslColor.withLightness((lightness).clamp(0.0, 1.0));

  // Convert the new HSLColor back to a Color object and return it
  return hslLight.toColor();
}

// Function to darken a given color by a certain amount (using HSL color model)
Color darkenColor(Color color, double amount) {
  // Make sure the amount is within the expected range
  assert(amount >= 0 && amount <= 1);

  // Convert the color to an HSLColor object
  final hslColor = HSLColor.fromColor(color);

  // Calculate the new lightness value by subtracting the amount from the current lightness value
  final lightness = hslColor.lightness - amount;

  // Create a new HSLColor object with the new lightness value, clamped to a range of 0.0 to 1.0
  final hslDark = hslColor.withLightness((lightness).clamp(0.0, 1.0));

  // Convert the new HSLColor back to a Color object and return it
  return hslDark.toColor();
}
