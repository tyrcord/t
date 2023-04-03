import 'package:tbloc/tbloc.dart';

import 'people_bloc_state.mock.dart';

class UnidirectionalPeopleBloc extends UnidirectionalBloc<PeopleBlocState> {
  UnidirectionalPeopleBloc({
    PeopleBlocState? initialState,
    BlocStateBuilder<PeopleBlocState>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  void put(PeopleBlocState state) {
    setState(state);
  }

  BlocThrottleCallback putThrottle(BlocThrottleCallback function) =>
      throttle(function);

  BlocDebounceCallback putDebounce(BlocDebounceCallback function) =>
      debounce(function);
}
