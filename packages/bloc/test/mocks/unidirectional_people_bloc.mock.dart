// Project imports:
import 'package:tbloc/tbloc.dart';
import 'people_bloc_state.mock.dart';

class UnidirectionalPeopleBloc extends UnidirectionalBloc<PeopleBlocState> {
  UnidirectionalPeopleBloc({
    super.initialState,
    super.initialStateBuilder,
  });

  void put(PeopleBlocState state) {
    setState(state);
  }

  BlocThrottleCallback putThrottle(BlocThrottleCallback function) =>
      throttle(function);

  BlocDebounceCallback putDebounce(BlocDebounceCallback function) =>
      debounce(function);
}
