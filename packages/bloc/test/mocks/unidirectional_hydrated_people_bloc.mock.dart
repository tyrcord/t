// Project imports:
import 'package:tbloc/tbloc.dart';
import 'people_bloc_state.mock.dart';
import 'people_bloc_store.mock.dart';

class UnidirectionalHydratedPeopleBloc
    extends UnidirectionalHydratedBloc<PeopleBlocState> {
  UnidirectionalHydratedPeopleBloc({
    super.initialState,
    super.initialStateBuilder,
  }) : super(
          store: PeopleBlocStore(),
          persitenceKey: 'uni_people_bloc',
        );

  Future<PeopleBlocState?> getLastPersistedState() {
    return store.retrieve(persitenceKey);
  }

  Future<void> put(PeopleBlocState state) async {
    await store.persist(persitenceKey, state);
    setState(state);
  }
}
