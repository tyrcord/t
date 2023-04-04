import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('isDoubleInteger', () {
    test('Test case 1: Input is a double integer', () {
      double x = 5.0;
      expect(isDoubleInteger(x), true);
    });

    test('Test case 2: Input is not a double integer', () {
      double y = 2.5;
      expect(isDoubleInteger(y), false);
    });

    test('Test case 3: Input is a negative double integer', () {
      double z = -10.0;
      expect(isDoubleInteger(z), true);
    });

    test(
        'Test case 4: Input is a small double value that is not a double integer',
        () {
      double a = 0.000001;
      expect(isDoubleInteger(a), false);
    });

    test(
        'Test case 5: Input is a large double value that is not a double integer',
        () {
      double b = 100000000.123;
      expect(isDoubleInteger(b), false);
    });
  });
}
