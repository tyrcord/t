// Package imports:
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

List<String>? _supportedLocales;

final Map<String, bool> _initializedLocales = {};

List<String> get supportedLocales {
  _supportedLocales ??=
      dateTimeSymbolMap().keys.toList().cast<String>().toList();

  return _supportedLocales!;
}

Future<String> formatDateTime(
  DateTime dateTime, {
  String languageCode = 'en',
  String? countryCode,
  bool alwaysUse24HourFormat = false,
}) async {
  final dateFormatter = await retrieveDateFormatter(
    languageCode: languageCode,
    countryCode: countryCode,
    alwaysUse24HourFormat: alwaysUse24HourFormat,
  );

  return dateFormatter.format(dateTime);
}

Future<DateFormat> retrieveDateFormatter({
  String languageCode = 'en',
  String? countryCode,
  bool alwaysUse24HourFormat = false,
}) async {
  var locale = languageCode;

  if (countryCode != null) {
    locale += '_$countryCode';
  }

  if (!supportedLocales.contains(locale)) {
    if (supportedLocales.contains(languageCode)) {
      locale = languageCode;
    } else {
      locale = 'en_ISO';
    }
  }

  if (!_initializedLocales.containsKey(locale)) {
    await initializeDateFormatting(locale);
    _initializedLocales[locale] = true;
  }

  var dateFormatter = DateFormat.yMd(locale);

  if (alwaysUse24HourFormat) {
    dateFormatter = dateFormatter.add_Hms();
  } else {
    dateFormatter = dateFormatter.add_jms();
  }

  return dateFormatter;
}
