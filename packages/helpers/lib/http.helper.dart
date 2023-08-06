bool isValidUrl(String input) {
  // Try parsing the input string as a URL
  final uri = Uri.tryParse(input);

  // If the uri is not null, and it has a scheme, then it's a valid URL
  return uri != null && uri.hasScheme;
}
