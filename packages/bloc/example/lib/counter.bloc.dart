// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

class CounterBloc
    extends BidirectionalBloc<CounterBlocEvent, CounterBlocState> {
  CounterBloc() : super(initialState: CounterBlocState());

  @override
  // ignore: code-metrics
  Stream<CounterBlocState> mapEventToState(CounterBlocEvent event) async* {
    final counter = currentState.counter;
    final type = event.type;

    if (type == CounterBlocEventType.init) {
      debugPrint('CounterBloc: init event received');
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);
      await Future.delayed(const Duration(seconds: 2));
      addEvent(const CounterBlocEvent.initialized());
    } else if (type == CounterBlocEventType.initialized) {
      debugPrint('CounterBloc: initialized event received');
      isInitialized = true;
      yield currentState.copyWith(isInitializing: false, isInitialized: true);
    } else if (type == CounterBlocEventType.increment) {
      debugPrint('CounterBloc: increment event received');
      yield currentState.copyWith(counter: counter + 1, isBusy: true);
    } else if (type == CounterBlocEventType.decrement) {
      debugPrint('CounterBloc: decrement event received');
      final step = counter > 0 ? counter - 1 : 0;
      yield currentState.copyWith(
        isBusy: step > 0 ? true : false,
        counter: step,
      );
    } else if (type == CounterBlocEventType.reset) {
      debugPrint('CounterBloc: reset event received');
      yield currentState.copyWith(counter: 0, isBusy: false);
    } else if (type == CounterBlocEventType.error) {
      throw 'error';
    } else if (type == CounterBlocEventType.errorRaised) {
      debugPrint('CounterBloc: errorRaised event received');
      yield currentState.copyWith(error: 'error');
    }
  }

  @override
  void handleInternalError(error, stackTrace) {
    addEvent(const CounterBlocEvent.errorRaised());
  }
}

class CounterBlocState extends BlocState {
  final int counter;

  CounterBlocState({
    super.isInitializing,
    super.isInitialized,
    super.isBusy,
    this.counter = 0,
    super.error,
  });

  @override
  CounterBlocState copyWith({
    bool? isInitializing,
    bool? isInitialized,
    bool? isBusy,
    dynamic error,
    int? counter,
  }) {
    return CounterBlocState(
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      counter: counter ?? this.counter,
      isBusy: isBusy ?? this.isBusy,
      error: error,
    );
  }

  @override
  CounterBlocState clone() => copyWith();

  @override
  CounterBlocState merge(covariant CounterBlocState model) {
    return copyWith(
      isInitializing: model.isInitializing,
      isInitialized: model.isInitialized,
      counter: model.counter,
      isBusy: model.isBusy,
      error: model.error,
    );
  }

  @override
  List<dynamic> get props => [
        counter,
        error,
        isBusy,
        isInitialized,
        isInitializing,
      ];
}

enum CounterBlocEventType {
  increment,
  decrement,
  reset,
  errorRaised,
  error,
  init,
  initialized,
}

class CounterBlocEvent extends BlocEvent<CounterBlocEventType, dynamic> {
  const CounterBlocEvent({super.type});

  const CounterBlocEvent.init() : this(type: CounterBlocEventType.init);

  const CounterBlocEvent.initialized()
      : this(type: CounterBlocEventType.initialized);

  const CounterBlocEvent.increment()
      : this(type: CounterBlocEventType.increment);

  const CounterBlocEvent.decrement()
      : this(type: CounterBlocEventType.decrement);

  const CounterBlocEvent.error() : this(type: CounterBlocEventType.error);

  const CounterBlocEvent.reset() : this(type: CounterBlocEventType.reset);

  const CounterBlocEvent.errorRaised()
      : this(type: CounterBlocEventType.errorRaised);
}
