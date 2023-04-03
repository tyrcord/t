import 'package:flutter/material.dart';
import 'package:tbloc/tbloc.dart';

class CounterBloc
    extends BidirectionalBloc<CounterBlocEvent, CounterBlocState> {
  CounterBloc() : super(initialState: CounterBlocState());

  @override
  // ignore: code-metrics
  Stream<CounterBlocState> mapEventToState(CounterBlocEvent event) async* {
    var counter = currentState.counter;
    final type = event.type;

    if (type == CounterBlocEventType.init) {
      debugPrint('CounterBloc: init event received');
      isInitializing = true;
      yield currentState.copyWith(isInitializing: true);
      await Future.delayed(Duration(seconds: 2));
      addEvent(CounterBlocEvent.initialized());
    } else if (type == CounterBlocEventType.initialized) {
      debugPrint('CounterBloc: initialized event received');
      isInitialized = true;
      yield currentState.copyWith(isInitializing: false, isInitialized: true);
    } else if (type == CounterBlocEventType.increment) {
      debugPrint('CounterBloc: increment event received');
      yield currentState.copyWith(counter: counter + 1, isBusy: true);
    } else if (type == CounterBlocEventType.decrement) {
      debugPrint('CounterBloc: decrement event received');
      var step = counter > 0 ? counter - 1 : 0;
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
  void handleInternalError(error) {
    addEvent(CounterBlocEvent.errorRaised());
  }
}

class CounterBlocState extends BlocState {
  final int counter;

  const CounterBlocState({
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
  CounterBlocState clone() {
    return CounterBlocState(
      isInitializing: isInitializing,
      isInitialized: isInitialized,
      counter: counter,
      isBusy: isBusy,
      error: error,
    );
  }

  @override
  CounterBlocState merge(covariant CounterBlocState state) {
    return copyWith(
      isInitializing: state.isInitializing,
      isInitialized: state.isInitialized,
      counter: state.counter,
      isBusy: state.isBusy,
      error: state.error,
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

  CounterBlocEvent.init() : this(type: CounterBlocEventType.init);

  CounterBlocEvent.initialized() : this(type: CounterBlocEventType.initialized);

  CounterBlocEvent.increment() : this(type: CounterBlocEventType.increment);

  CounterBlocEvent.decrement() : this(type: CounterBlocEventType.decrement);

  CounterBlocEvent.error() : this(type: CounterBlocEventType.error);

  CounterBlocEvent.reset() : this(type: CounterBlocEventType.reset);

  CounterBlocEvent.errorRaised() : this(type: CounterBlocEventType.errorRaised);
}
