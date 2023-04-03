import 'package:tmodel/tmodel.dart';

/// Base class for all states of a [TBloc].
abstract class BlocState extends TModel {
  /// Whether the bloc is initializing.
  final bool isInitializing;

  /// Whether the bloc is initialized.
  final bool isInitialized;

  /// Whether the bloc has an error.
  final dynamic error;

  /// Whether the bloc is busy.
  final bool isBusy;

  /// Indicates whether the bloc has an error.
  bool get hasError => error != null;

  const BlocState({
    this.isInitializing = false,
    this.isInitialized = false,
    this.isBusy = false,
    this.error,
  });
}
