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

List<num> rangeAroundN(double n, int x, {bool loose = false}) {
  // Start from max(1.0, n-x) to ensure numbers are greater than 0
  final double start = n - x < 1.0 ? 1.0 : n - x;

  // End at n+x, and in Dart, the end is exclusive, so we use n+x+0.1 to
  // include n+x in the range
  final double end = n + x + 0.1;

  // Generate the list of numbers from start to end
  final List<num> result = [];

  for (double i = start; i < end; i += 1.0) {
    if (loose && i != n) {
      // If loose is true, convert to int, except for the central value 'n'
      result.add(i.toInt());
    } else {
      // Otherwise, add as double
      result.add(i);
    }
  }

  return result;
}

const double kEpsilon = 1e-10;

bool nearlyEqual(
  num a,
  num b, {
  double epsilon = kEpsilon,
}) {
  return (a - b).abs() < epsilon;
}
