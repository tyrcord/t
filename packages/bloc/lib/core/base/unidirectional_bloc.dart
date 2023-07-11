// Project imports:
import 'package:tbloc/tbloc.dart';

/// A UnidirectionalBloc is a subset of Bloc which has no notion of events and
/// relies on methods to emit new states.
abstract class UnidirectionalBloc<S extends BlocState> extends Bloc<S> {
  UnidirectionalBloc({
    super.initialState,
    super.initialStateBuilder,
  });
}
