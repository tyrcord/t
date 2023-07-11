// ignore_for_file: overridden_fields

// Package imports:
import 'package:meta/meta.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// Takes a Stream of BlocEvents as input and transforms them into a Stream of
/// BlocStates as output.
abstract class BidirectionalHydratedBloc<E extends BlocEvent,
        S extends HydratedBlocState> extends BidirectionalBloc<E, S>
    with HydratedBlocMixin<S> {
  /// The [BlocStore] used to hydrate the bloc.
  @override
  @protected
  final BlocStore<S> store;

  /// The key used to retrieve the state from the [store].
  @override
  @protected
  final String persitenceKey;

  /// Indicates if the bloc is hydrated.
  @override
  @protected
  bool isBlocHydrated = false;

  @override
  Function(BlocEvent) get addEvent {
    assert(isBlocHydrated);

    return super.addEvent;
  }

  BidirectionalHydratedBloc({
    required this.store,
    required this.persitenceKey,
    super.initialStateBuilder,
    super.initialState,
    super.eventStateHistorySize = 50,
    super.enableForceBuildEvents = false,
  }) {
    subxList.add(onData.listen((S state) {
      Stream.fromFuture(store.persist(persitenceKey, state));
    }));
  }
}
