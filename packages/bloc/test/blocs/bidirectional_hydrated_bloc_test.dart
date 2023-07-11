@Timeout(Duration(seconds: 5))

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import '../mocks/bidirectional_hydrated_people_bloc.mock.dart';
import '../mocks/people_bloc_event.mock.dart';
import '../mocks/people_bloc_state.mock.dart';

void main() {
  group('BidirectionalHydratedPeopleBloc', () {
    late BidirectionalHydratedPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = BidirectionalHydratedPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.close();
    });

    group('#BidirectionalHydratedPeopleBloc()', () {
      test('should return a BidirectionalHydratedPeopleBloc object', () {
        expect(
          // ignore: unnecessary_type_check
          BidirectionalHydratedPeopleBloc(
            initialState: defaultState,
          ) is BidirectionalHydratedPeopleBloc,
          equals(true),
        );
      });
    });

    group('#hydrate()', () {
      test('should retrieve and set the lasted persited state', () async {
        final bloc2 = BidirectionalHydratedPeopleBloc(
          initialState: defaultState,
        );

        await bloc.hydrate();

        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(
              age: 24,
            ),
          ),
        );

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
