T? getValue<T>(T? value, {T? defaultValue, bool loose = true}) {
  if (loose) {
    if (value != null && looseValue(value) == null) {
      return looseValue(defaultValue);
    }

    return looseValue(value) ?? defaultValue;
  }

  return value ?? defaultValue;
}

T? looseValue<T>(T? value) {
  if (value is String) {
    final tmpString = value.trim();

    if (tmpString.isEmpty) {
      return null;
    }
  } else if (value is List && value.isEmpty) {
    return null;
  } else if (value is Map && value.isEmpty) {
    return null;
  }

  return value;
}
