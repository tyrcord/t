import 'package:flutter_test/flutter_test.dart';
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
      expect(toCamelCase('HelloWorld'), 'helloworld');
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
    test('should return language code if no country code is provided', () {
      expect(toIos3166Code('en'), equals('en'));
      expect(toIos3166Code('fr'), equals('fr'));
    });

    test('should return language code and uppercase country code if provided',
        () {
      expect(toIos3166Code('en', countryCode: 'us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'ca'), equals('fr_CA'));
      expect(toIos3166Code('fr', countryCode: ''), equals('fr'));
    });

    test(
        'should return language code and uppercase country code if lowercase country code is provided',
        () {
      expect(toIos3166Code('en', countryCode: 'us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'ca'), equals('fr_CA'));
    });

    test(
        'should return language code and uppercase country code if mixed case country code is provided',
        () {
      expect(toIos3166Code('en', countryCode: 'Us'), equals('en_US'));
      expect(toIos3166Code('fr', countryCode: 'cA'), equals('fr_CA'));
    });
  });
}
