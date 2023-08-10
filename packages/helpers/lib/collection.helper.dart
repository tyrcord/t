// Dart imports:
import 'dart:math';

/// Transforms a flat list into a 2D list with the given number of [columns].
///
/// If the input [array] is empty, an empty 2D list is returned.
///
/// Example usage:
///
/// ```dart
/// final flatList = [1, 2, 3, 4, 5, 6];
/// final twoDList = transformTo2DArray(flatList, 3);
/// ```
List<List<T>> transformTo2DArray<T>(List<T> array, int columns) {
  if (array.isEmpty) {
    return [];
  }

  final rows = (array.length / columns).ceil();
  final result = <List<T>>[];

  for (int i = 0; i < rows; i++) {
    final row = <T>[];

    for (int j = 0; j < columns; j++) {
      final int index = i * columns + j;

      if (index >= array.length) {
        break;
      }

      row.add(array[index]);
    }

    result.add(row);
  }

  return result;
}

T? getRandomItem<T>(List<T> list) {
  if (list.isEmpty) {
    return null;
  }

  final random = Random();
  final randomIndex = random.nextInt(list.length);

  return list[randomIndex];
}
