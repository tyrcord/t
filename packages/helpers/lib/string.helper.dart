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
///
/// Returns the converted string in camel case format.
String toCamelCase(String? input) {
  if (input == null || input.isEmpty) {
    return '';
  }

  final words = input.trim().split(RegExp(r'[_\s-]+'));

  var result = words[0].toLowerCase();

  for (var i = 1; i < words.length; i++) {
    result += words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
  }

  return result;
}

/// Converts a string [text] to title case format.
///
/// If the [text] is null or empty, an empty string is returned.
/// The function trims leading and trailing whitespace from the [text]
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
String toTitleCase(String? text) {
  if (text == null || text.isEmpty) {
    return '';
  }

  final words = text.trim().split(RegExp(r'\s+'));

  final capitalizedWords = words.map((word) {
    if (word.isEmpty) {
      return word; // Skip empty words (consecutive spaces)
    }

    final firstLetter = word.substring(0, 1).toUpperCase();
    final restOfWord = word.substring(1).toLowerCase();

    return '$firstLetter$restOfWord';
  });

  return capitalizedWords.join(' ');
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
String toIos3166Code(String languageCode, {String? countryCode}) {
  if (countryCode != null && countryCode.isNotEmpty) {
    countryCode = countryCode.toUpperCase();

    return '${languageCode}_$countryCode';
  }

  return languageCode;
}
