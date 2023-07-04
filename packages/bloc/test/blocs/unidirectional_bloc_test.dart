@Timeout(Duration(seconds: 5))

import 'package:flutter_test/flutter_test.dart';

import '../mocks/people_bloc_state.mock.dart';
import '../mocks/unidirectional_people_bloc.mock.dart';

void main() {
  group('UnidirectionalBloc', () {
    late UnidirectionalPeopleBloc bloc;

    final defaultState = PeopleBlocState(
      age: 42,
      firstname: 'foo',
      lastname: 'bar',
    );

    setUp(() {
      bloc = UnidirectionalPeopleBloc(
        initialState: defaultState,
      );
    });

    tearDown(() {
      bloc.close();
    });

    group('#UnidirectionalPeopleBloc()', () {
      test('should return a UnidirectionalPeopleBloc object', () {
        expect(
            // ignore: unnecessary_type_check
            UnidirectionalPeopleBloc(initialState: defaultState)
                is UnidirectionalPeopleBloc,
            equals(true));
      });

      test('should initialize its state', () async {
        bloc = UnidirectionalPeopleBloc(
          initialState: defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));

        bloc = UnidirectionalPeopleBloc(
          initialStateBuilder: () => defaultState,
        );

        expect(bloc.currentState.firstname, equals('foo'));
        expect(bloc.currentState.lastname, equals('bar'));
        expect(bloc.currentState.age, equals(42));
      });
    });

    group('#onData', () {
      test('should be an Stream', () {
        // ignore: unnecessary_type_check
        expect(bloc.onData is Stream, equals(true));
      });

      test('should dispatch states when BLoC\'s states change', () async {
        expect(
          bloc.onData.take(3).map((state) => state.firstname),
          emitsInOrder([
            'foo',
            'baz',
            'qux',
            emitsDone,
          ]),
        );

        bloc.put(PeopleBlocState(firstname: 'baz'));
        bloc.put(PeopleBlocState(firstname: 'qux'));
      });
    });

    group('#currentState', () {
      test(
        'should return the inital state when a BLoC has been instantiated',
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
          bloc.put(PeopleBlocState(firstname: 'baz'));

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
      test('should close Bloc streams', () {
        expect(
          bloc.onData.skip(1).map((state) => state.age),
          neverEmits(12),
        );

        bloc.close();
        bloc.put(PeopleBlocState(age: 12));
        expect(bloc.isClosed, equals(true));
      });
    });

    group('#throttle()', () {
      test('should return a throttled function', () async {
        var count = 0;

        final throttled = bloc.putThrottle(([Map<dynamic, dynamic>? extras]) {
          count++;
        });

        throttled();
        throttled();
        throttled();

        expect(count, equals(0));

        await Future.delayed(
          const Duration(milliseconds: 350),
          () => expect(count, equals(1)),
        );
      });
    });

    group('#debounce()', () {
      test('should return a debounced function', () async {
        int? count = 0;

        final void Function([Map<dynamic, dynamic>]) debounced =
            bloc.putDebounce(([Map<dynamic, dynamic>? extras]) {
          count = extras!['count'] as int?;
        });

        debounced({'count': 1});
        debounced({'count': 2});
        debounced({'count': 3});

        expect(count, equals(0));

        await Future.delayed(
          const Duration(milliseconds: 350),
          () => expect(count, equals(3)),
        );
      });
    });
  });
}
