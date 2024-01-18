// Package imports:
import 'package:diacritic/diacritic.dart';

/// Converts a string [input] to camel case format.
///
/// If the [input] is null or empty, an empty string is returned.
/// The function trims leading and trailing whitespace from the [input]
/// and splits it into an array of words using underscores, spaces, and hyphens
/// as delimiters. It then converts the first word to lowercase and appends
/// the capitalized version of each subsequent word (except the first word)
/// to the result. The remaining characters in each word are converted to
/// lowercase.
///
/// Example:
///   toCamelCase('hello_world') => 'helloWorld'
///   toCamelCase('hello-world') => 'helloWorld'
///   toCamelCase('hello world') => 'helloWorld'
///   toCamelCase('HelloWorld') => 'helloWorld'
///
/// Returns the converted string in camel case format.
String toCamelCase(String? input) {
  if (input == null || input.isEmpty) return '';

  final words = input.trim().split(RegExp(r'[_\s-]+|(?<=[a-z])(?=[A-Z])'));
  final buffer = StringBuffer()..write(words[0].toLowerCase());

  for (var i = 1; i < words.length; i++) {
    if (words[i].length > 1) {
      buffer
        ..write(words[i][0].toUpperCase())
        ..write(words[i].substring(1).toLowerCase());
    } else {
      buffer.write(words[i].toUpperCase());
    }
  }

  return buffer.toString();
}

/// Converts a string [input] to title case format.
///
/// If the [input] is null or empty, an empty string is returned.
/// The function trims leading and trailing whitespace from the [input]
/// and splits it into an array of words using whitespace as the delimiter.
/// It then capitalizes the first letter of each word and converts the
/// remaining characters in each word to lowercase. Consecutive spaces
/// are skipped, preserving only non-empty words.
///
/// Example:
///   toTitleCase('hello world') => 'Hello World'
///   toTitleCase('the quick brown fox') => 'The Quick Brown Fox'
///
/// Returns the converted string in title case format.
String toTitleCase(String? input) {
  if (input == null || input.isEmpty) return '';

  final words = input.trim().split(RegExp(r'\s+'));

  final capitalizedWords = words.where((word) => word.isNotEmpty).map((word) {
    final firstLetter = word[0].toUpperCase();
    final restOfWord = word.substring(1).toLowerCase();

    return firstLetter + restOfWord;
  });

  return capitalizedWords.join(' ');
}

/// Converts a string [input] to pascal case format.
///
/// If the [input] is null or empty, an empty string is returned.
/// The function trims leading and trailing whitespace from the [input]
/// and splits it into an array of words using underscores, spaces, and hyphens
/// as delimiters. Each word (including the first word) is capitalized
/// and appended to the result string. The remaining characters in each word
/// are converted to lowercase.
///
/// Example:
///   toPascalCase('hello_world') => 'HelloWorld'
///   toPascalCase('hello-world') => 'HelloWorld'
///   toPascalCase('hello world') => 'HelloWorld'
///   toPascalCase('HelloWorld') => 'HelloWorld'
///
/// Returns the converted string in pascal case format.
String toPascalCase(String? input) {
  if (input == null || input.isEmpty) return '';

  // Split the string at spaces, underscores, hyphens, or camelCase boundaries.
  final words = input.trim().split(RegExp(r'[_\s-]+|(?<=[a-z])(?=[A-Z])'));

  var result = '';

  for (final word in words) {
    result += word[0].toUpperCase() + word.substring(1).toLowerCase();
  }

  return result;
}

/// Converts a language code and an optional country code to an ISO 3166 code.
///
/// If a [countryCode] is provided, it is converted to uppercase and appended to
/// the [languageCode] with an underscore separator. Otherwise, only the
/// [languageCode] is returned.
///
/// Example:
///
/// ```dart
/// toIos3166Code('en', countryCode: 'us'); // 'en_US'
/// toIos3166Code('fr'); // 'fr'
/// ```
String? toIos3166Code(String languageCode, {String? countryCode}) {
  languageCode = languageCode.trim();

  if (languageCode.isEmpty) {
    return null;
  }

  if (countryCode != null) {
    countryCode = countryCode.trim();

    if (countryCode.isNotEmpty) {
      countryCode = countryCode.toUpperCase();

      return '${languageCode}_$countryCode';
    }
  }

  return languageCode;
}

/// Removes diacritics (accents) from the given [text] and then converts
/// it to lowercase.
///
/// For instance:
///
/// ```dart
/// var input = "ÁbČDè";
/// var output = removeDiacriticsAndLowercase(input);
/// print(output);  // Outputs "abcde"
/// ```
///
/// [text]: The text to be processed.
///
/// Returns a new string without diacritics and in lowercase.
String removeDiacriticsAndLowercase(String text) {
  return removeDiacritics(text.toLowerCase());
}

/// Returns the last character of a given string after trimming it if
/// specified.
///
/// If [trim] is set to `true`, the string will be trimmed to remove
/// whitespace from the ends before extracting the last character.
///
/// Throws an [ArgumentError] if the input string is empty (or becomes
/// empty after trimming).
///
/// - Parameters:
///   - [value]: The input string.
///   - [trim]: A boolean flag that decides if the string should be
///     trimmed. Defaults to `true`.
///
/// - Returns: The last character of the input string.
String getLastChar(String value, {bool trim = true}) {
  if (trim) value = value.trim();

  if (value.isEmpty) throw ArgumentError('Value cannot be empty');

  final character = value.substring(value.length - 1);

  return character;
}
