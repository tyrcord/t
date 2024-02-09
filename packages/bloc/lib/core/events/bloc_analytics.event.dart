class BlocAnalyticsEvent<T> {
  final Map<String, dynamic>? parameters;
  final DateTime timestamp;
  final T type;

  BlocAnalyticsEvent({
    required this.type,
    this.parameters,
  }) : timestamp = DateTime.now();
}
