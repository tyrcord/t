// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'bidirectional_people_bloc.mock.dart';
import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleAsyncBloc extends BidirectionalPeopleBloc {
  BidirectionalPeopleAsyncBloc({
    super.initialState,
    super.initialStateBuilder,
  });

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
