class BlocAnalyticsEvent {
  final String eventType;
  final Map<String, dynamic>? parameters;
  final DateTime timestamp;

  BlocAnalyticsEvent(
    this.eventType,
    this.parameters,
  ) : timestamp = DateTime.now();
}
