import 'package:tbloc/tbloc.dart';

import 'bidirectional_people_bloc.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleBloc2 extends BidirectionalPeopleBloc {
  BidirectionalPeopleBloc2({
    PeopleBlocState? initialState,
    BlocStateBuilder<PeopleBlocState>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @override
  bool canClose() {
    return false;
  }
}
