// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('toCamelCase', () {
    test('should return an empty string when input is null', () {
      expect(toCamelCase(null), '');
    });

    test('should return an empty string when input is empty', () {
      expect(toCamelCase(''), '');
    });

    test('should convert PascalCase to camelCase', () {
      expect(toCamelCase('HelloWorld'), 'helloWorld');
    });

    test('should convert snake_case to camelCase', () {
      expect(toCamelCase('hello_world'), 'helloWorld');
      expect(toCamelCase('my_variable_name'), 'myVariableName');
    });

    test('should convert kebab-case to camelCase', () {
      expect(toCamelCase('hello-world'), 'helloWorld');
      expect(toCamelCase('my-variable-name'), 'myVariableName');
    });

    test('should convert space separated words to camelCase', () {
      expect(toCamelCase('hello world'), 'helloWorld');
      expect(toCamelCase('my variable name'), 'myVariableName');
    });

    test('should handle leading and trailing spaces', () {
      expect(toCamelCase('  hello world  '), 'helloWorld');
      expect(toCamelCase('  my variable name  '), 'myVariableName');
    });

    test('should handle consecutive spaces', () {
      expect(toCamelCase('hello   world'), 'helloWorld');
      expect(toCamelCase('my   variable   name'), 'myVariableName');
    });

    test('should handle consecutive underscores', () {
      expect(toCamelCase('hello___world'), 'helloWorld');
      expect(toCamelCase('my___variable___name'), 'myVariableName');
    });

    test('should handle consecutive dashes', () {
      expect(toCamelCase('hello---world'), 'helloWorld');
      expect(toCamelCase('my---variable---name'), 'myVariableName');
    });

    test('should handle mixed separators', () {
      expect(toCamelCase('hello_world-my-variable name'),
          'helloWorldMyVariableName');
      expect(toCamelCase('my-variable_name hello_world'),
          'myVariableNameHelloWorld');
    });
  });

  group('toTitleCase', () {
    test('should return an empty string when input is null', () {
      expect(toTitleCase(null), '');
    });

    test('should return an empty string when input is empty', () {
      expect(toTitleCase(''), '');
    });

    test('should capitalize the first letter of each word', () {
      expect(toTitleCase('hello world'), 'Hello World');
      expect(toTitleCase('my name is john'), 'My Name Is John');
    });

    test('should handle leading and trailing spaces', () {
      expect(toTitleCase('  hello world  '), 'Hello World');
      expect(toTitleCase('  my name is john  '), 'My Name Is John');
    });

    test('should handle consecutive spaces', () {
      expect(toTitleCase('hello   world'), 'Hello World');
      expect(toTitleCase('my   name   is   john'), 'My Name Is John');
    });

    test('should handle single-letter words', () {
      expect(toTitleCase('a b c'), 'A B C');
      expect(toTitleCase('i am a boy'), 'I Am A Boy');
    });

    test('should handle non-alphabetic characters', () {
      expect(toTitleCase('123 hello world'), '123 Hello World');
      expect(toTitleCase('my name is john!'), 'My Name Is John!');
    });
  });

  group('toIos3166', () {
    test('returns null when languageCode is empty', () {
      expect(toIos3166Code('', countryCode: 'us'), isNull);
      expect(toIos3166Code('', countryCode: ''), isNull);
      expect(toIos3166Code('', countryCode: null), isNull);
    });

    test('should return language code if no country code is provided', () {
      expect(toIos3166Code('en'), equals('en'));
      expect(toIos3166Code('en  '), equals('en'));
      expect(toIos3166Code('fr'), equals('fr'));
      expect(toIos3166Code('  fr'), equals('fr'));
      expect(toIos3166Code('  fr   '), equals('fr'));
    });

    test('should return language code and uppercase country code if provided',
        () {
      expect(toIos3166Code('en', countryCode: 'us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'ca'), equals('fr_CA'));
      expect(toIos3166Code('en', countryCode: null), equals('en'));
      expect(toIos3166Code('fr', countryCode: ''), equals('fr'));
      expect(toIos3166Code('fr', countryCode: '  '), equals('fr'));
      expect(toIos3166Code('fr', countryCode: ' ca '), equals('fr_CA'));
    });

    test(
        'should return language code and uppercase country code if lowercase '
        'country code is provided', () {
      expect(toIos3166Code('en', countryCode: 'us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'ca'), equals('fr_CA'));
    });

    test(
        'should return language code and uppercase country code if mixed case '
        'country code is provided', () {
      expect(toIos3166Code('en', countryCode: 'Us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'cA'), equals('fr_CA'));
    });
  });

  group('removeDiacriticsAndLowercase', () {
    test(
        'removeDiacriticsAndLowercase should remove diacritics '
        'and convert to lowercase', () {
      expect(removeDiacriticsAndLowercase("ÁbČDè"), "abcde");
      expect(removeDiacriticsAndLowercase("HELLO"), "hello");
      expect(removeDiacriticsAndLowercase("ÇÖlË"), "cole");
      expect(removeDiacriticsAndLowercase("áÉíÓú"), "aeiou");
      expect(removeDiacriticsAndLowercase(""), "");
      expect(removeDiacriticsAndLowercase("No Diacritics Here"),
          "no diacritics here");
    });
  });

  group('getLastChar tests', () {
    test('Should return the last character of a string', () {
      expect(getLastChar('hello'), 'o');
    });

    test(
        'Should return the last character of a string with trailing spaces '
        'when trim is true', () {
      expect(getLastChar('hello '), 'o');
    });

    test(
        'Should return the last character of a string with leading spaces '
        'when trim is true', () {
      expect(getLastChar(' hello'), 'o');
    });

    test('Should return a space as the last character when trim is false', () {
      expect(getLastChar('hello ', trim: false), ' ');
    });

    test('Should throw ArgumentError when string is empty', () {
      expect(() => getLastChar(''), throwsArgumentError);
    });

    test(
        'Should throw ArgumentError when string is only whitespace and '
        'trim is true', () {
      expect(() => getLastChar('  '), throwsArgumentError);
    });

    test(
        'Should not throw ArgumentError when string is only whitespace and '
        'trim is false', () {
      expect(getLastChar('  ', trim: false), ' ');
    });
  });

  group('toPascalCase', () {
    test('Converts hello_world to HelloWorld', () {
      expect(toPascalCase('hello_world'), 'HelloWorld');
    });

    test('Converts hello-world to HelloWorld', () {
      expect(toPascalCase('hello-world'), 'HelloWorld');
    });

    test('Converts hello world to HelloWorld', () {
      expect(toPascalCase('hello world'), 'HelloWorld');
    });

    test('Handles empty string', () {
      expect(toPascalCase(''), '');
    });

    test('Handles null input', () {
      expect(toPascalCase(null), '');
    });

    test('Converts a to A', () {
      expect(toPascalCase('a'), 'A');
    });

    test('Converts a_b_c to ABC', () {
      expect(toPascalCase('a_b_c'), 'ABC');
    });

    test('Handles string with multiple spaces', () {
      expect(toPascalCase('hello   world'), 'HelloWorld');
    });

    test('Handles all uppercase string', () {
      expect(toPascalCase('HELLO WORLD'), 'HelloWorld');
    });

    test('Handles string starting with numbers', () {
      expect(toPascalCase('123hello world'), '123helloWorld');
    });

    test('Handles string with special characters', () {
      expect(toPascalCase('helloWorld!'), 'HelloWorld!');
    });

    test('Converts complex mixed case string', () {
      expect(
        toPascalCase('this_is-a Complex_stringExample'),
        'ThisIsAComplexStringExample',
      );
    });

    test('Handles non-English characters', () {
      expect(toPascalCase('élève brillant'), 'ÉlèveBrillant');
    });
  });
}
