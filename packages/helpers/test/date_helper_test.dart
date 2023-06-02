import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  group('formatDateTime', () {
    test('should format a date in the default locale', () async {
      final dateTime = DateTime(2022, 1, 1, 12, 0, 0);
      final formattedDate = await formatDateTime(dateTime);

      expect(formattedDate, equals('1/1/2022 12:00:00 PM'));
    });

    test('should format a date in a specific locale', () async {
      final dateTime = DateTime(2022, 1, 1, 12, 0, 0);
      final formattedDate = await formatDateTime(dateTime, languageCode: 'fr');

      expect(formattedDate, '01/01/2022 12:00:00');
    });

    test('should format a date in a specific locale and country', () async {
      final dateTime = DateTime(2022, 1, 1, 12, 0, 0);
      final formattedDate = await formatDateTime(
        dateTime,
        languageCode: 'fr',
        countryCode: 'CH',
      );

      expect(formattedDate, '01.01.2022 12:00:00');
    });

    test('should format a date using 24-hour format', () async {
      final dateTime = DateTime(2022, 1, 1, 15, 0, 0);
      final formattedDate = await formatDateTime(
        dateTime,
        alwaysUse24HourFormat: true,
      );

      expect(formattedDate, '1/1/2022 15:00:00');
    });
  });

  group('retrieveDateFormatter', () {
    test('retrieveDateFormatter should return a DateFormat object', () async {
      final dateFormatter = await retrieveDateFormatter();

      expect(dateFormatter, isA<DateFormat>());
    });

    test(
      'retrieveDateFormatter should return a DateFormat object with '
      'the correct locale',
      () async {
        final dateFormatter = await retrieveDateFormatter(
          languageCode: 'fr',
          countryCode: 'CH',
        );

        expect(dateFormatter.locale.toString(), equals('fr_CH'));
      },
    );

    test(
      'retrieveDateFormatter should return a DateFormat object with '
      '24-hour format when alwaysUse24HourFormat is true',
      () async {
        final dateFormatter = await retrieveDateFormatter(
          alwaysUse24HourFormat: true,
        );

        expect(dateFormatter.pattern, equals('M/d/y HH:mm:ss'));
      },
    );

    test(
        'retrieveDateFormatter should return a DateFormat object with '
        '12-hour format when alwaysUse24HourFormat is false', () async {
      final dateFormatter = await retrieveDateFormatter(
        alwaysUse24HourFormat: false,
      );

      expect(dateFormatter.pattern, equals('M/d/y h:mm:ss a'));
    });
  });
}
