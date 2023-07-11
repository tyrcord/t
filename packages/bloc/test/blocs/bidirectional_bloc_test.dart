@Timeout(Duration(seconds: 5))

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';
import '../mocks/bidirectional_people_async_bloc.mock.dart';
import '../mocks/bidirectional_people_bloc.mock.dart';
import '../mocks/bidirectional_people_bloc2.mock.dart';
import '../mocks/people_bloc_event.mock.dart';
import '../mocks/people_bloc_state.mock.dart';

void main() {
  group('BidirectionalBloc', () {
    late BidirectionalPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = BidirectionalPeopleBloc(initialState: defaultState);
    });

    tearDown(() {
      bloc.close();
    });

    group('#BidirectionalPeopleBloc()', () {
      test('should return a BidirectionalPeopleBloc object', () {
        expect(
          // ignore: unnecessary_type_check
          BidirectionalPeopleBloc(initialState: defaultState)
              is BidirectionalPeopleBloc,
          equals(true),
        );
      });

      test('should initialize its state', () async {
        bloc = BidirectionalPeopleBloc(
          initialState: defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));

        bloc = BidirectionalPeopleBloc(
          initialStateBuilder: () => defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));
      });
    });

    group('#addEvent()', () {
      test('should update a BLoC\'s state when an Event is dispatched',
          () async {
        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(
              age: 12,
              lastname: 'qux',
            ),
          ),
        );

        final lastState = await bloc.onData.skip(1).first;

        expect(
          lastState ==
              PeopleBlocState(
                age: 12,
                firstname: 'foo',
                lastname: 'qux',
              ),
          equals(true),
        );
      });

      test(
        'should update a BLoC\'s state when mapEventToState yield more '
        'than one state',
        () async {
          final people = bloc.currentState;

          expect(
            bloc.onData.skip(1).take(2),
            emitsInOrder([
              people.copyWith(age: 1),
              people.copyWith(age: 1, firstname: 'multi'),
            ]),
          );

          bloc.addEvent(const PeopleBlocEvent.updateMultipleInformation());
        },
      );

      test('should adds events to the history', () async {
        final event = PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(
            age: 12,
            lastname: 'qux',
          ),
        );

        expect(bloc.getEventStateHistory(), isEmpty);

        bloc.addEvent(event);

        final nextState = await bloc.onData.skip(1).first;

        expect(bloc.getEventStateHistory(), contains(event));
        expect(bloc.getEventStateHistory()[event], contains(nextState.uuid));
      });
    });

    group('#getEventForState', () {
      test('should returns the event related to a state', () async {
        final event = PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(
            age: 12,
            lastname: 'qux',
          ),
        );

        final expectedState = PeopleBlocState(
          firstname: 'foo',
          lastname: 'qux',
          age: 12,
        );

        bloc.addEvent(event);

        final lastState = await bloc.onData.skip(1).first;
        final eventFound = bloc.getEventForState(lastState);

        expect(eventFound == event, equals(true));
        expect(lastState == expectedState, equals(true));
      });

      test('should returns null if the state is not found', () {
        final state = PeopleBlocState(
          firstname: 'foo',
          lastname: 'qux',
          age: 12,
        );

        final result = bloc.getEventForState(state);

        expect(result, isNull);
      });
    });

    group('#onData', () {
      test('should be an Stream', () {
        // ignore: unnecessary_type_check
        expect(bloc.onData is Stream, equals(true));
      });

      test(
        'should dispatch states when a BLoC\'s states change',
        () async {
          expect(
            bloc.onData.take(3).map((state) => state.firstname),
            emitsInOrder([
              'foo',
              'baz',
              'qux',
              emitsDone,
            ]),
          );

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(firstname: 'baz'),
            ),
          );

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(firstname: 'qux'),
            ),
          );
        },
      );

      test(
        'should dispatch states in order when a BLoC\'s states change',
        () async {
          var i = 0;

          expect(
            bloc.onData.skip(1).take(3).map((state) {
              i++;

              if (i == 3) {
                return state.lastname;
              }

              return state.isSingle;
            }),
            emitsInOrder([
              true,
              false,
              'married',
              emitsDone,
            ]),
          );

          bloc.addEvent(const PeopleBlocEvent.marrySomeone());
        },
      );

      test(
        'should not dispatch states in order '
        'when the method shouldProcessEventInOrder returns false',
        () async {
          var bloc2 = BidirectionalPeopleAsyncBloc(initialState: defaultState);

          expect(
            bloc2.onData.skip(1).take(1),
            emitsInOrder([
              defaultState.copyWith(age: 88),
              emitsDone,
            ]),
          );

          bloc2.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 12),
            ),
          );

          bloc2.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 88),
            ),
          );
        },
      );

      test(
        'should not dispatch states when the state has not changed',
        () async {
          var count = 0;
          listenCallback(state) => count++;
          var listenCallbackAsync1 = expectAsync1(listenCallback, count: 1);
          var event = PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(
              age: 12,
              lastname: 'qux',
            ),
          );

          bloc.onData.skip(1).listen(listenCallbackAsync1);

          bloc.addEvent(event);
          bloc.addEvent(event);

          await Future.delayed(const Duration(milliseconds: 300), () {
            expect(count, equals(1));
          });
        },
      );
    });

    group('#onError', () {
      test('should be an Stream', () {
        // ignore: unnecessary_type_check
        expect(bloc.onError is Stream, equals(true));
      });

      test('should dispatch an error when an error occurs', () async {
        expect(
          bloc.onError.take(1).map((BlocError error) => error.source),
          emitsInOrder([
            'error',
            emitsDone,
          ]),
        );

        bloc.addEvent(const PeopleBlocEvent.error());
      });
    });

    group('#onEvent', () {
      test('should be an Stream', () {
        // ignore: unnecessary_type_check
        expect(bloc.onEvent is Stream, equals(true));
      });

      test(
        'should dispatch an event when an event is added to a BloC',
        () async {
          final event = PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(firstname: 'baz'),
          );

          expect(
            bloc.onEvent.take(1),
            emitsInOrder([
              event,
              emitsDone,
            ]),
          );

          bloc.addEvent(event);
        },
      );
    });

    group('#currentState', () {
      test(
        'should return the initial state when a BLoC has been instantiated',
        () {
          final state = bloc.currentState;
          expect(state.firstname, equals('foo'));
          expect(state.lastname, equals('bar'));
          expect(state.age, equals(42));
        },
      );

      test(
        'should return the latest state '
        'when a BLoC\'s state has been updated',
        () async {
          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(firstname: 'baz'),
            ),
          );

          final lastState = await bloc.onData
              .skipWhile((state) => state.firstname != 'baz')
              .first;

          expect(
            lastState == bloc.currentState,
            equals(true),
          );
        },
      );
    });

    group('#close()', () {
      test('should close bloC onData stream and block new events', () async {
        expect(
          bloc.onData.map((state) => state.age),
          neverEmits(12),
        );

        // micro task async
        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(age: 12),
          ),
        );

        // sync
        bloc.close();

        // micro task async
        bloc.addEvent(
          PeopleBlocEvent.updateInformation(
            payload: PeopleBlocEventPayload(age: 12),
          ),
        );

        expect(bloc.isClosed, equals(true));
      });

      test('should silent bloC errors', () async {
        expect(
          bloc.onError.map((state) => 1),
          neverEmits(1),
        );

        // micro task async
        bloc.addEvent(const PeopleBlocEvent.errorDelayed());

        // wait for event to be handled
        await Future.delayed(const Duration(milliseconds: 50));

        bloc.close();

        expect(bloc.isClosed, equals(true));

        // wait for the delayed error to be raised
        await Future.delayed(const Duration(milliseconds: 150));
      });
    });

    group('#throttleEvent()', () {
      test('should return a throttled function', () async {
        final throttled = bloc.putThrottleEvent(
          (event) => bloc.addEvent(event),
        );

        throttled(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'baz'),
        ));

        throttled(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'qux'),
        ));

        throttled(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'foo'),
        ));

        await Future.delayed(
          const Duration(milliseconds: 150),
          () {
            final state = bloc.currentState;
            expect(state.firstname, equals('baz'));
          },
        );

        await Future.delayed(
          const Duration(milliseconds: 350),
          () {
            final state = bloc.currentState;
            expect(state.firstname, equals('baz'));
          },
        );
      });
    });

    group('#debounceEvent()', () {
      test('should return a debounced function', () async {
        final debounced = bloc.putDebounceEvent(
          (event) => bloc.addEvent(event),
        );

        debounced(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'baz'),
        ));

        debounced(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'qux'),
        ));

        debounced(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'quz'),
        ));

        await Future.delayed(
          const Duration(milliseconds: 150),
          () {
            final state = bloc.currentState;
            expect(state.firstname, equals('foo'));
          },
        );

        await Future.delayed(
          const Duration(milliseconds: 350),
          () {
            final state = bloc.currentState;
            expect(state.firstname, equals('quz'));
          },
        );
      });
    });

    group('#sampleEvent()', () {
      test('should sample events at a fixed interval', () async {
        final debouncedFunction = bloc.putSampleEvent(
          (event) => bloc.addEvent(event),
        );

        // Add three events to the debounced function at 100ms intervals
        debouncedFunction(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'baz'),
        ));

        debouncedFunction(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'qux'),
        ));

        await Future.delayed(const Duration(milliseconds: 350));

        debouncedFunction(PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(firstname: 'quz'),
        ));

        expect(bloc.currentState.firstname, equals('qux'));

        await Future.delayed(const Duration(milliseconds: 350));

        expect(bloc.currentState.firstname, equals('quz'));
      });
    });

    group('#canClose()', () {
      test(
        'should allow to override the default behavior of the close method',
        () async {
          bloc = BidirectionalPeopleBloc2(initialState: defaultState);

          bloc.close();

          // micro task async
          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 12),
            ),
          );

          await Future.delayed(
            const Duration(milliseconds: 0),
            () {
              final state = bloc.currentState;
              expect(state.age, equals(12));
            },
          );

          expect(bloc.isClosed, equals(false));
        },
      );
    });
  });
}
