/// Calculates the percentage decrease between an [originalValue]
/// and a [newValue].
///
/// The [originalValue] represents the initial value, and the [newValue]
/// represents the updated value. The method calculates the decrease as
/// the difference between the original value and the new value, and then
/// calculates the percentage decrease by dividing the decrease by the original
/// value. The resulting percentage decrease is returned as a [double].
double calculatePercentageDecrease(double originalValue, double newValue) {
  if (originalValue == 0) return 0.0;

  // Calculate the decrease and percentage decrease
  final decrease = originalValue - newValue;
  final percentageDecrease = decrease / originalValue;

  // Convert the percentage decrease to a double and return it
  return percentageDecrease;
}
