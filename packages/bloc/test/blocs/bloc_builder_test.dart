import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:tbloc/tbloc.dart';

import '../mocks/bidirectional_people_bloc.mock.dart';
import '../mocks/people_bloc_event.mock.dart';
import '../mocks/people_bloc_state.mock.dart';

Widget _buildApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

void main() {
  group('BlocBuilder', () {
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

    group('#buildWhen', () {
      testWidgets(
        'Should only re-build the widget when the predicate is equal to true',
        (WidgetTester tester) async {
          var buildWhenCalled = false;
          var counter = 0;

          await tester.pumpWidget(_buildApp(BlocBuilderWidget(
            bloc: bloc,
            buildWhen: (PeopleBlocState previous, PeopleBlocState next) {
              buildWhenCalled = true;

              if (counter == 0) {
                expect(previous.age, 42);
                expect(next.age, 20);
              } else if (counter == 1) {
                expect(previous.age, 20);
                expect(next.age, 18);
              } else if (counter == 2) {
                expect(previous.age, 18);
                expect(next.age, 22);
              }

              counter++;

              return next.age! > 20;
            },
            builder: (_, PeopleBlocState state) {
              return Text(state.age.toString());
            },
          )));

          var textFinder = find.text('42');
          expect(textFinder, findsOneWidget);

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 20),
            ),
          );

          var state;

          await tester.runAsync(() async {
            state = await bloc.onData.skip(1).first;
          });

          expect(state.age, equals(20));

          await tester.pumpAndSettle();

          textFinder = find.text('20');

          expect(textFinder, findsNothing);
          expect(buildWhenCalled, isTrue);

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 18),
            ),
          );

          await tester.runAsync(() async {
            state = await bloc.onData.skip(1).first;
          });

          expect(state.age, equals(18));

          await tester.pumpAndSettle();

          textFinder = find.text('18');
          expect(textFinder, findsNothing);

          bloc.addEvent(
            PeopleBlocEvent.updateInformation(
              payload: PeopleBlocEventPayload(age: 22),
            ),
          );

          await tester.runAsync(() async {
            state = await bloc.onData.skip(1).first;
          });

          expect(state.age, equals(22));

          await tester.pumpAndSettle();

          textFinder = find.text('22');
          expect(textFinder, findsOneWidget);
        },
      );
    });
  });
}
