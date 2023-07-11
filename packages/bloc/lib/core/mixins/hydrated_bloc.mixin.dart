// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// A mixin that provides the ability to hydrate a [Bloc].
mixin HydratedBlocMixin<S extends HydratedBlocState> on Bloc<S> {
  /// The [BlocStore] used to hydrate the bloc.
  @protected
  late BlocStore<S> store;

  /// The key used to retrieve the state from the [store].
  @protected
  late String persitenceKey;

  /// Indicates if the bloc is hydrated.
  @protected
  bool isBlocHydrated = false;

  /// Hydrates the bloc.
  /// - If the bloc is already hydrated, this method does nothing.
  /// - If the bloc is not hydrated, this method will try to retrieve the
  ///  state from the [store] and set it as the current state.
  /// - If the bloc is not hydrated and the state cannot be retrieved from
  /// the [store], the current state will be used.
  Future<void> hydrate() async {
    if (!isBlocHydrated) {
      var candidateState = await store.retrieve(persitenceKey);
      candidateState ??= currentState;

      setState(candidateState.copyWith(hydrated: true) as S);
      isBlocHydrated = true;
    }
  }
}
