// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Project imports:
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

    test('should format date without time when showTime is false', () async {
      final dateTime = DateTime(2023, 7, 18, 10, 30);
      final formatted = await formatDateTime(dateTime, showTime: false);

      expect(formatted, '7/18/2023');
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

    test('should format date without time when showTime is false', () async {
      final formatter = await retrieveDateFormatter(showTime: false);

      final dateTime = DateTime(2023, 7, 18, 10, 30);
      final formatted = formatter.format(dateTime);

      expect(formatted, '7/18/2023');
    });

    test('should format date with time when showTime is true', () async {
      final formatter = await retrieveDateFormatter(showTime: true);

      final dateTime = DateTime(2023, 7, 18, 10, 30);
      final formatted = formatter.format(dateTime);

      // Modify the expected formatted string based on the desired time format
      expect(formatted, '7/18/2023 10:30:00 AM');
    });
  });
}
