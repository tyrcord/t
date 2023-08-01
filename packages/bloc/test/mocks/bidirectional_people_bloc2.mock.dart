// Project imports:
import 'bidirectional_people_bloc.mock.dart';

class BidirectionalPeopleBloc2 extends BidirectionalPeopleBloc {
  BidirectionalPeopleBloc2({
    super.initialState,
    super.initialStateBuilder,
  });

  @override
  bool canClose() {
    return false;
  }
}
