/// Formats a currency pair using a base and quote currency, and optionally
/// includes a delimiter.
///
/// This function takes in two required parameters: `baseCurrency` and
/// `quoteCurrency`, which represent the two parts of the currency pair. An
/// optional `delimiter` can be specified to separate the two currencies in the
/// returned string. If no delimiter is provided or if it's an empty string,
/// the currencies will be concatenated without any separator.
///
/// ```
/// // Example without delimiter:
/// String currencyPair = formatCurrencyPair(
///     baseCurrency: 'USD', quoteCurrency: 'EUR');
/// print(currencyPair); // Output: USDEUR
///
/// // Example with delimiter:
/// String currencyPairWithDelimiter = formatCurrencyPair(
///     baseCurrency: 'USD', quoteCurrency: 'EUR', delimiter: '/');
/// print(currencyPairWithDelimiter); // Output: USD/EUR
/// ```
///
/// [baseCurrency]: The base currency code in the pair.
/// [quoteCurrency]: The quote currency code in the pair.
/// [delimiter]: An optional string to separate the base and quote currencies.
String formatCurrencyPair({
  required String baseCurrency,
  required String quoteCurrency,
  String? delimiter,
}) {
  String formattedPair = baseCurrency.toUpperCase();

  if (delimiter != null && delimiter.isNotEmpty) {
    formattedPair += delimiter;
  }

  formattedPair += quoteCurrency.toUpperCase();

  return formattedPair;
}
