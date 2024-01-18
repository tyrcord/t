// Package imports:
import 'package:intl/intl.dart';

String getCurrencySymbol({String? localeCode, String? currencyCode = 'USD'}) {
  currencyCode ??= 'USD';

  final format = NumberFormat.simpleCurrency(
    name: currencyCode.toUpperCase(),
    locale: localeCode,
  );

  return format.currencySymbol;
}
