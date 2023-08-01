// Project imports:
import 'package:tbloc/tbloc.dart';
import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';
import 'people_bloc_store.mock.dart';

class BidirectionalHydratedPeopleBloc
    extends BidirectionalHydratedBloc<PeopleBlocEvent, PeopleBlocState> {
  BidirectionalHydratedPeopleBloc({
    super.initialState,
    super.initialStateBuilder,
  }) : super(
          store: PeopleBlocStore(),
          persitenceKey: 'people_bloc',
        );

  @override
  Stream<PeopleBlocState> mapEventToState(PeopleBlocEvent event) async* {
    yield currentState.copyWithPayload(event.payload!);
  }

  Future<PeopleBlocState?> getLastPersistedState() {
    return store.retrieve(persitenceKey);
  }
}
