// ignore_for_file: overridden_fields

import 'package:meta/meta.dart';

import 'package:tbloc/tbloc.dart';

/// A UnidirectionalHydratedBloc is a subset of Bloc which has no notion of
/// events and relies on methods to emit new states.
abstract class UnidirectionalHydratedBloc<S extends HydratedBlocState>
    extends UnidirectionalBloc<S> with HydratedBlocMixin<S> {
  /// The [BlocStore] used to hydrate the bloc.
  @override
  @protected
  final BlocStore<S> store;

  /// The key used to retrieve the state from the [store].
  @override
  @protected
  final String persitenceKey;

  UnidirectionalHydratedBloc({
    required this.store,
    required this.persitenceKey,
    super.initialStateBuilder,
    super.initialState,
  });
}
