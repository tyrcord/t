import 'package:flutter_test/flutter_test.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('getValue', () {
    test('returns value when not null and not empty', () {
      expect(getValue('hello'), equals('hello'));
    });

    test('returns default value when value is null', () {
      expect(getValue(null, defaultValue: 'world'), equals('world'));
    });

    test('returns default value when value is empty and loose is true', () {
      expect(getValue('', defaultValue: 'world', loose: true), equals('world'));
    });

    test('should not returns null when value is empty and loose is false', () {
      expect(getValue('', defaultValue: 'world', loose: false), '');
    });

    test(
        'returns empty string when value is empty and loose is false '
        'and default value is not provided', () {
      expect(getValue('', loose: false), equals(''));
    });

    test('returns null when value is null and default value is not provided',
        () {
      expect(getValue(null), isNull);
    });

    test(
        'returns null when value is empty and loose is true '
        'and default value is not provided', () {
      expect(getValue('', loose: true), isNull);
      expect(getValue(' ', loose: true), isNull);
    });

    test(
        'returns value when value is not empty and loose is true '
        'and default value is provided', () {
      expect(
        getValue('hello', defaultValue: 'world', loose: true),
        equals('hello'),
      );
    });

    test(
        'returns value when value is not empty and loose is false '
        'and default value is provided', () {
      expect(
        getValue('hello', defaultValue: 'world', loose: false),
        equals('hello'),
      );
    });
  });

  group('looseValue', () {
    test('returns null for empty string', () {
      expect(looseValue(''), isNull);
    });

    test('returns null for empty list', () {
      expect(looseValue([]), isNull);
    });

    test('returns null for empty map', () {
      expect(looseValue({}), isNull);
    });

    test('returns value for non-empty string', () {
      expect(looseValue('hello'), equals('hello'));
    });

    test('returns value for non-empty list', () {
      expect(looseValue([1, 2, 3]), equals([1, 2, 3]));
    });

    test('returns value for non-empty map', () {
      expect(looseValue({'key': 'value'}), equals({'key': 'value'}));
    });
  });
}
