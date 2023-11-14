/// Formats a currency pair using a base and counter currency, and optionally
/// includes a delimiter.
///
/// This function takes in two required parameters: `baseCurrency` and
/// `counterCurrency`, which represent the two parts of the currency pair. An
/// optional `delimiter` can be specified to separate the two currencies in the
/// returned string. If no delimiter is provided or if it's an empty string,
/// the currencies will be concatenated without any separator.
///
/// ```
/// // Example without delimiter:
/// String currencyPair = formatCurrencyPair(
///     baseCurrency: 'USD', counterCurrency: 'EUR');
/// print(currencyPair); // Output: USDEUR
///
/// // Example with delimiter:
/// String currencyPairWithDelimiter = formatCurrencyPair(
///     baseCurrency: 'USD', counterCurrency: 'EUR', delimiter: '/');
/// print(currencyPairWithDelimiter); // Output: USD/EUR
/// ```
///
/// [baseCurrency]: The base currency code in the pair.
/// [counterCurrency]: The counter currency code in the pair.
/// [delimiter]: An optional string to separate the base and counter currencies.
String formatCurrencyPair({
  required String base,
  required String counter,
  String? delimiter,
}) {
  String formattedPair = base.toUpperCase();

  if (delimiter != null && delimiter.isNotEmpty) {
    formattedPair += delimiter;
  }

  formattedPair += counter.toUpperCase();

  return formattedPair;
}
