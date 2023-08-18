// Dart imports:
import 'dart:developer';

// Project imports:
import 'package:tbloc/tbloc.dart';
import 'people_bloc_event.mock.dart';
import 'people_bloc_state.mock.dart';

class BidirectionalPeopleBloc
    extends BidirectionalBloc<PeopleBlocEvent, PeopleBlocState> {
  BidirectionalPeopleBloc({
    super.initialState,
    super.initialStateBuilder,
  }) : super(
          enableForceBuildEvents: true,
        );

  @override
  Stream<PeopleBlocState> mapEventToState(PeopleBlocEvent event) async* {
    if (event.type == PeopleBlocEventPayloadType.error) {
      throw event.error!;
    } else if (event.type == PeopleBlocEventPayloadType.updateInformation) {
      yield currentState.copyWithPayload(event.payload!);
    } else if (event.type == PeopleBlocEventPayloadType.marry) {
      yield currentState.copyWith(isMarrying: true);
      await Future.delayed(const Duration(milliseconds: 300));
      addEvent(const PeopleBlocEvent.married());
    } else if (event.type == PeopleBlocEventPayloadType.married) {
      yield currentState.copyWith(isSingle: false, isMarrying: false);
      addEvent(
        PeopleBlocEvent.updateInformation(
          payload: PeopleBlocEventPayload(lastname: 'married'),
        ),
      );
    } else if (event.type == PeopleBlocEventPayloadType.multiple) {
      yield currentState.copyWithPayload(PeopleBlocEventPayload(age: 1));

      yield currentState.copyWithPayload(
        PeopleBlocEventPayload(firstname: 'multi'),
      );
    } else if (event.type == PeopleBlocEventPayloadType.errorDelayed) {
      await Future.delayed(const Duration(milliseconds: 150));
      log('error delayed will be raised');

      throw 'Error Delayed';
    }
  }

  @override
  // ignore: no-empty-block
  void handleInternalError(dynamic error, StackTrace stackTrace) {
    if (error == 'Error Delayed') {
      addEvent(const PeopleBlocEvent.error());
    }
  }

  BlocEventCallback<PeopleBlocEvent> putThrottleEvent(
    BlocEventCallback<PeopleBlocEvent> function,
  ) {
    return throttleEvent(function);
  }

  BlocEventCallback<PeopleBlocEvent> putDebounceEvent(
    BlocEventCallback<PeopleBlocEvent> function,
  ) {
    return debounceEvent(function);
  }

  BlocEventCallback<PeopleBlocEvent> putSampleEvent(
    BlocEventCallback<PeopleBlocEvent> function,
  ) {
    return sampleEvent(function);
  }

  Map<PeopleBlocEvent, List<String>> getEventStateHistory() {
    return eventStateHistory;
  }
}
