// Package imports:
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:t_helpers/helpers.dart';

/// List of supported locale strings.
List<String>? _supportedLocales;

/// Tracks which locales have been initialized.
final Map<String, bool> _initializedLocales = {};

/// Ensures the locale is initialized for date formatting.
///
/// If the locale is not supported, it defaults to English (ISO standard).
/// Only initializes the locale once.
Future<void> _initializeLocaleIfNeeded(String locale) async {
  if (!supportedLocales.contains(locale)) {
    final languageCode = locale.substring(0, 2);
    locale = supportedLocales.contains(languageCode) ? languageCode : 'en_ISO';
  }

  if (!_initializedLocales.containsKey(locale)) {
    await initializeDateFormatting(locale);
    _initializedLocales[locale] = true;
  }
}

/// Constructs a locale identifier from language and country codes.
///
/// If the conversion to an iOS 3166 code is not possible, it defaults to
/// English (ISO standard).
String _buildLocale(String languageCode, String? countryCode) {
  return toIos3166Code(languageCode, countryCode: countryCode) ?? 'en_ISO';
}

/// Getter for supported locales.
///
/// If `_supportedLocales` is null, initializes it with the keys from the
/// `dateTimeSymbolMap` function, casting them to a list of strings.
List<String> get supportedLocales {
  _supportedLocales ??=
      dateTimeSymbolMap().keys.toList().cast<String>().toList();

  return _supportedLocales!;
}

/// Formats a [DateTime] object into a string.
///
/// Allows specifying whether to use a 24-hour format, language code,
/// country code, and whether to show time.
Future<String> formatDateTime(
  DateTime dateTime, {
  bool use24HourFormat = false,
  String languageCode = 'en',
  bool showTime = true,
  String? countryCode,
}) async {
  final dateFormatter = await retrieveDateFormatter(
    use24HourFormat: use24HourFormat,
    languageCode: languageCode,
    countryCode: countryCode,
    showTime: showTime,
  );

  return dateFormatter.format(dateTime);
}

/// Retrieves a [DateFormat] object based on locale and preferences.
///
/// Initializes the locale if needed before creating the date formatter.
Future<DateFormat> retrieveDateFormatter({
  bool use24HourFormat = false,
  String languageCode = 'en',
  bool showTime = true,
  String? countryCode,
}) async {
  final locale = _buildLocale(languageCode, countryCode);
  await _initializeLocaleIfNeeded(locale);

  return createDateFormatter(locale, showTime, use24HourFormat);
}

/// Creates a date formatter based on the locale and preferences.
///
/// If [showTime] is true, the time is added to the formatter using either
/// a 24-hour or AM/PM format.
DateFormat createDateFormatter(
  String locale,
  bool showTime,
  bool use24HourFormat,
) {
  DateFormat dateFormatter = DateFormat.yMd(locale);

  if (showTime) {
    dateFormatter =
        use24HourFormat ? dateFormatter.add_Hms() : dateFormatter.add_jms();
  }

  return dateFormatter;
}

/// Formats a timestamp in milliseconds since epoch into a date string.
///
/// The timestamp must be positive, and this function supports
/// all options provided by `formatDateTime`.
Future<String> formatTimestampInMilliseconds({
  required int timestamp,
  bool use24HourFormat = false,
  String languageCode = 'en',
  bool showTime = true,
  String? countryCode,
  bool isUtc = false,
}) async {
  if (timestamp < 0) {
    throw ArgumentError('timestamp must be a positive integer');
  }

  return formatDateTime(
    DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: isUtc),
    use24HourFormat: use24HourFormat,
    languageCode: languageCode,
    countryCode: countryCode,
    showTime: showTime,
  );
}
