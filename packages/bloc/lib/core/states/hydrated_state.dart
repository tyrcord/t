import 'bloc_state.dart';

/// Base class for all states of a [TBloc] that can be hydrated.
abstract class HydratedBlocState extends BlocState {
  /// Whether the bloc is hydrated.
  final bool hydrated;

  HydratedBlocState({
    this.hydrated = false,
    super.isInitializing,
    super.isInitialized,
    super.isBusy,
    super.error,
  });

  @override
  HydratedBlocState copyWith({bool? hydrated});
}
