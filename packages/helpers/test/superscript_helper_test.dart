// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:t_helpers/helpers.dart';

void main() {
  group('replaceLastCharacterWithSuperscript', () {
    test('replaces last number with superscript', () {
      expect(superscriptLastCharacter('x0'), 'x⁰');
      expect(superscriptLastCharacter('x2'), 'x²');
    });

    test('replaces last letter with superscript', () {
      expect(superscriptLastCharacter('na'), 'nᵃ');
      expect(superscriptLastCharacter('force m'), 'force ᵐ');
      expect(superscriptLastCharacter('H2O'), 'H2ᵒ');
    });

    test('throws for characters without superscript equivalents', () {
      expect(
        () => superscriptLastCharacter('hello!'),
        throwsStateError,
      );
      expect(
        () => superscriptLastCharacter('99!'),
        throwsStateError,
      );
    });

    test('returns same string if last character is already a superscript', () {
      const alreadySuperscript = 'x²';

      expect(superscriptLastCharacter(alreadySuperscript), 'x²');
    });

    test('handles empty string', () {
      expect(
        () => superscriptLastCharacter(''),
        throwsArgumentError,
      );
    });
  });
}
