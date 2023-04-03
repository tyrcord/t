@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/people_bloc_state.mock.dart';
import '../mocks/unidirectional_hydrated_people_bloc.mock.dart';

void main() {
  group('UnidirectionalHydratedPeopleBloc', () {
    late UnidirectionalHydratedPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = UnidirectionalHydratedPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.close();
    });

    group('#UnidirectionalHydratedPeopleBloc()', () {
      test('should return a UnidirectionalHydratedPeopleBloc object', () {
        expect(
          UnidirectionalHydratedPeopleBloc(
            initialState: defaultState,
          ) is UnidirectionalHydratedPeopleBloc,
          equals(true),
        );
      });
    });

    group('#hydrate()', () {
      test('should retrieve and set the lasted persited state', () async {
        final bloc2 = UnidirectionalHydratedPeopleBloc(
          initialState: defaultState,
        );

        await bloc.hydrate();
        await bloc.put(PeopleBlocState(age: 24));

        // wait for the state to be updated
        await Future.delayed(
          const Duration(microseconds: 100),
          () => bloc2.hydrate(),
        );

        expect(
          bloc.currentState.age == 24,
          equals(true),
        );

        expect(
          bloc2.currentState.age == 24,
          equals(true),
        );
      });
    });
  });
}
