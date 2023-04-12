/// Checks if the input [number] is a "double integer", i.e., a double value
/// that represents an integer value.
/// Returns true if the input [number] is a double integer, false otherwise.
bool isDoubleInteger(double number) {
  // Compute the rounded value of the input [number] using the roundToDouble() method
  double roundedValue = number.roundToDouble();

  // Compare the rounded value to the input [number]. If they are equal, the input
  // [number] is a double integer, so return true. Otherwise, it is not a double
  // integer, so return false.
  return number == roundedValue;
}

bool isNumber(String str) {
  final doubleValue = double.tryParse(str);

  return doubleValue != null;
}
