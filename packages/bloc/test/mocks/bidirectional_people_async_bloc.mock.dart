import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';

import 'bidirectional_people_bloc.mock.dart';
import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleAsyncBloc extends BidirectionalPeopleBloc {
  BidirectionalPeopleAsyncBloc({
    PeopleBlocState? initialState,
    BlocStateBuilder<PeopleBlocState>? initialStateBuilder,
  }) : super(
          initialState: initialState,
          initialStateBuilder: initialStateBuilder,
        );

  @protected
  @override
  bool shouldProcessEventInOrder() => false;

  @override
  Stream<PeopleBlocState> mapEventToState(PeopleBlocEvent event) async* {
    if (event.type == PeopleBlocEventPayloadType.updateInformation) {
      // simulate DB writing...
      await Future.delayed(const Duration(milliseconds: 50));
      yield currentState.copyWithPayload(event.payload!);
    } else {
      yield* super.mapEventToState(event);
    }
  }
}
