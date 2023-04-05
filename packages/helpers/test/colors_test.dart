import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  test('lightenColor should lighten a color by the specified amount', () {
    const originalColor = Colors.blue;
    const amount = 0.2;
    const expectedColor = Color(0xff82c4f8); // Lightened by 20%
    final actualColor = lightenColor(originalColor, amount);
    expect(actualColor, equals(expectedColor));
  });

  test('darkenColor should darken a color by the specified amount', () {
    const originalColor = Colors.blue;
    const amount = 0.2;
    const expectedColor = Color(0xff0960a5); // Darkened by 20%
    final actualColor = darkenColor(originalColor, amount);
    expect(actualColor, equals(expectedColor));
  });

  test('lightenColor should return white when amount is 1', () {
    const originalColor = Colors.blue;
    const amount = 1.0;
    const expectedColor = Colors.white;
    final actualColor = lightenColor(originalColor, amount);
    expect(actualColor, equals(expectedColor));
  });

  test('darkenColor should return black when amount is 1', () {
    const originalColor = Colors.blue;
    const amount = 1.0;
    const expectedColor = Colors.black;
    final actualColor = darkenColor(originalColor, amount);
    expect(actualColor, equals(expectedColor));
  });

  test('lightenColor should throw an AssertionError when amount is less than 0',
      () {
    const originalColor = Colors.blue;
    const amount = -0.1;
    expect(() => lightenColor(originalColor, amount),
        throwsA(isA<AssertionError>()));
  });

  test('darkenColor should throw an AssertionError when amount is less than 0',
      () {
    const originalColor = Colors.blue;
    const amount = -0.1;
    expect(() => darkenColor(originalColor, amount),
        throwsA(isA<AssertionError>()));
  });

  test(
      'lightenColor should throw an AssertionError when amount is greater than 1',
      () {
    const originalColor = Colors.blue;
    const amount = 1.1;
    expect(() => lightenColor(originalColor, amount),
        throwsA(isA<AssertionError>()));
  });

  test(
      'darkenColor should throw an AssertionError when amount is greater than 1',
      () {
    const originalColor = Colors.blue;
    const amount = 1.1;
    expect(() => darkenColor(originalColor, amount),
        throwsA(isA<AssertionError>()));
  });
}
