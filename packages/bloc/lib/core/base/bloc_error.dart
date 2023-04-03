/// BlocError is a class that contains the error information
class BlocError {
  /// The stack trace of the error.
  final StackTrace stackTrace;

  /// The error message.
  final String? message;

  /// The source of the error.
  final dynamic source;

  BlocError({
    required this.stackTrace,
    required this.source,
    this.message,
  });
}
