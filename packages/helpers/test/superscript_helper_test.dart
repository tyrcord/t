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

  group('revertSuperscripts', () {
    test('should revert superscript numbers', () {
      expect(revertSuperscripts('x²y³z⁴'), equals('x2y3z4'));
    });

    test('should revert superscript letters', () {
      expect(revertSuperscripts('aᵃbᵇcᶜ'), equals('aabbcc'));
    });

    test('should return the same string if no superscripts are present', () {
      expect(revertSuperscripts('Hello World'), equals('Hello World'));
    });

    test('should handle empty string', () {
      expect(revertSuperscripts(''), equals(''));
    });

    test('should handle string with only superscripts', () {
      expect(revertSuperscripts('⁰¹²³⁴⁵⁶⁷⁸⁹'), equals('0123456789'));
    });

    test('should handle string with no superscript equivalent', () {
      expect(revertSuperscripts('∆ΣΠ'), equals('∆ΣΠ'));
    });
  });
}
