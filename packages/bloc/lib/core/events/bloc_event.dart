import 'package:meta/meta.dart';

/// Base class for all events of a [TBloc].
@immutable
class BlocEvent<T, P> {
  /// The error of the event.
  final Object? error;

  /// The payload of the event.
  final P? payload;

  /// The type of the event.
  final T? type;

  const BlocEvent({
    this.payload,
    this.error,
    this.type,
  });
}
