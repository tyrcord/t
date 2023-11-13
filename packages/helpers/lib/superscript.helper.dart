import 'package:t_helpers/helpers.dart';

const kSuperscripts = {
  '0': '⁰',
  '1': '¹',
  '2': '²',
  '3': '³',
  '4': '⁴',
  '5': '⁵',
  '6': '⁶',
  '7': '⁷',
  '8': '⁸',
  '9': '⁹',
  'a': 'ᵃ',
  'b': 'ᵇ',
  'c': 'ᶜ',
  'd': 'ᵈ',
  'e': 'ᵉ',
  'f': 'ᶠ',
  'g': 'ᵍ',
  'h': 'ʰ',
  'i': 'ⁱ',
  'j': 'ʲ',
  'k': 'ᵏ',
  'l': 'ˡ',
  'm': 'ᵐ',
  'n': 'ⁿ',
  'o': 'ᵒ',
  'p': 'ᵖ',
  'r': 'ʳ',
  's': 'ˢ',
  't': 'ᵗ',
  'u': 'ᵘ',
  'v': 'ᵛ',
  'w': 'ʷ',
  'x': 'ˣ',
  'y': 'ʸ',
  'z': 'ᶻ',
};

const kSuperscriptsReverse = {
  '⁰': '0',
  '¹': '1',
  '²': '2',
  '³': '3',
  '⁴': '4',
  '⁵': '5',
  '⁶': '6',
  '⁷': '7',
  '⁸': '8',
  '⁹': '9',
  'ᵃ': 'a',
  'ᵇ': 'b',
  'ᶜ': 'c',
  'ᵈ': 'd',
  'ᵉ': 'e',
  'ᶠ': 'f',
  'ᵍ': 'g',
  'ʰ': 'h',
  'ⁱ': 'i',
  'ʲ': 'j',
  'ᵏ': 'k',
  'ˡ': 'l',
  'ᵐ': 'm',
  'ⁿ': 'n',
  'ᵒ': 'o',
  'ᵖ': 'p',
  'ʳ': 'r',
  'ˢ': 's',
  'ᵗ': 't',
  'ᵘ': 'u',
  'ᵛ': 'v',
  'ʷ': 'w',
  'ˣ': 'x',
  'ʸ': 'y',
  'ᶻ': 'z',
};

/// Checks if the given [character] is a superscript character.
///
/// Utilizes a predefined map of superscript characters, `kSuperscripts`,
/// to perform the check.
///
/// - Parameters:
///   - [character]: The character to check.
///
/// - Returns: `true` if [character] is a superscript, otherwise `false`.

bool isSuperscript(String character) {
  return kSuperscripts.values.contains(character);
}

/// Replaces the last character of the given [value] with its superscript
/// equivalent if available.
///
/// - Parameters:
///   - [value]: The string whose last character will be replaced.
///
/// - Returns: A new string with the last character replaced by its
///   superscript equivalent.
///
/// - Throws:
///   - [ArgumentError]: If [value] is empty.
///   - [StateError]: If there is no superscript equivalent for the last
///     character.
///
/// - Example:
///   ```
///   final result = replaceLastCharacterWithSuperscript('x2');
///   print(result); // Outputs: x²
///   ```
String superscriptLastCharacter(String value) {
  if (value.isEmpty) throw ArgumentError('Value cannot be empty');

  final character = getLastChar(value);
  final superscript = kSuperscripts[character.toLowerCase()];

  if (isSuperscript(character)) return value;

  if (superscript == null) {
    throw StateError('Superscript equivalent not found for $character');
  }

  return value.substring(0, value.length - 1) + superscript;
}

/// Reverts superscript characters in the given [value] to their normal
/// equivalents.
///
/// - Parameters:
///   - [value]: The string to process.
///
/// - Returns: A new string with all superscript characters reverted to normal.
///
/// - Example:
///   ```
///   final result = revertSuperscripts('x²y³');
///   print(result); // Outputs: x2y3
///   ```
String revertSuperscripts(String value) {
  final StringBuffer buffer = StringBuffer();

  for (int i = 0; i < value.length; i++) {
    final String char = value[i];
    buffer.write(kSuperscriptsReverse[char] ?? char);
  }

  return buffer.toString();
}
