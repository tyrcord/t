// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:rxdart/rxdart.dart';
import 'package:subx/subx.dart';
import 'package:tuple/tuple.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// Abstract Bloc which has no notion of events.
abstract class Bloc<S extends BlocState> {
  /// The state controller.
  @protected
  final BehaviorSubject<S> stateController = BehaviorSubject<S>();

  /// The error controller.
  @protected
  final PublishSubject<BlocError> errorController = PublishSubject<BlocError>();

  /// The initial state BloC builder.
  @protected
  final BlocStateBuilder<S>? initialStateBuilder;

  /// The list of publishers.
  @protected
  final List<PublishSubject> publishers = [];

  /// Whether the BloC is initializing.
  @protected
  bool isInitializing = false;

  @protected
  final subxList = SubxList();

  @protected
  final subxMap = SubxMap();

  /// The initial state of the BloC.
  @protected
  final S? initialState;

  /// Whether the BloC is closed.
  @protected
  bool closed = false;

  /// The current BloC's state.
  @protected
  late S blocState;

  /// Whether the BloC is initializing.
  @protected
  bool get isInitialized => _isInitialized;

  /// Whether the BloC is initialized.
  @protected
  set isInitialized(bool isInitialized) {
    if (isInitialized) {
      isInitializing = false;
    }

    _isInitialized = isInitialized;
  }

  bool _isInitialized = false;

  /// Whether the BloC can be initialized.
  @protected
  bool get canInitialize => !isInitialized && !isInitializing;

  /// Whether the BloC is closed for dispatching more events.
  bool get isClosed => closed;

  /// The current BloC's state.
  S get currentState => blocState;

  /// Called whenever the BloC's state is updated.
  Stream<S> get onData => stateController.stream.distinct();

  /// Called whenever the BloC's state is updated.
  Stream<BlocError> get onError => errorController.stream;

  Bloc({
    this.initialState,
    this.initialStateBuilder,
  }) {
    setState(getInitialState());
  }

  /// Tries to retreive the initial BloC's state.
  @protected
  S getInitialState() {
    if (initialState != null) {
      return initialState!;
    }

    if (initialStateBuilder != null) {
      return initialStateBuilder!();
    }

    return initState();
  }

  /// Optional callback method to initialize the BloC's state.
  @protected
  S initState() {
    const message = 'A BloC\'s state should be initialized when instancied';
    throw UnimplementedError(message);
  }

  /// Set the BloC state.
  @protected
  void setState(S nextState) {
    blocState = nextState;
    dispatchState(nextState);
  }

  /// Notifies the BloC of a new state which triggers `onData`.
  @protected
  Function(S) get dispatchState {
    if (!stateController.isClosed) {
      return stateController.sink.add;
    }

    return _dispatchState;
  }

  // ignore: no-empty-block
  void _dispatchState(S state) {}

  /// Transforms the error before it is emitted.
  @protected
  BlocError? transformError(dynamic error, StackTrace stackTrace) {
    return BlocError(source: error, stackTrace: stackTrace);
  }

  ///
  /// Creates a throttled function that only invokes [function] at most once
  /// per every [duration].
  ///
  /// For example:
  ///
  ///      final throttled = throttle(() {
  ///          // heavy stuff
  ///      });
  BlocThrottleCallback throttle(
    BlocThrottleCallback function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final throttler =
        PublishSubject<Tuple2<Function, Map<dynamic, dynamic>?>>();
    publishers.add(throttler);

    subxList.add(
      throttler.throttleTime(duration).listen(
        (Tuple2<Function, Map<dynamic, dynamic>?> tuple) {
          tuple.item1(tuple.item2);
        },
      ),
    );

    return ([Map<dynamic, dynamic>? extras]) {
      final tuple = Tuple2<Function, Map<dynamic, dynamic>?>(function, extras);
      throttler.add(tuple);
    };
  }

  ///
  /// Creates a debounced function that only invokes [function] after a [delay].
  ///
  /// For example:
  ///
  ///      final debounced = debounce(() {
  ///          // heavy stuff
  ///      });
  BlocDebounceCallback debounce(
    BlocDebounceCallback function, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    final debouncer =
        PublishSubject<Tuple2<Function, Map<dynamic, dynamic>?>>();
    publishers.add(debouncer);

    subxList.add(
      debouncer.debounceTime(delay).listen(
        (Tuple2<Function, Map<dynamic, dynamic>?> tuple) {
          tuple.item1(tuple.item2);
        },
      ),
    );

    return ([Map<dynamic, dynamic>? extras]) {
      final tuple = Tuple2<Function, Map<dynamic, dynamic>?>(function, extras);
      debouncer.add(tuple);
    };
  }

  /// Closes the BloC.
  /// This method should be called when the BloC is no longer needed.
  @mustCallSuper
  void close() {
    if (!closed && canClose()) {
      closed = true;
      stateController.close();
      errorController.close();
      subxList.cancelAll();
      subxMap.cancelAll();

      for (final publisher in publishers) {
        publisher.close();
      }
    }
  }

  /// Whether the BloC can be closed.
  /// Override this method to prevent the BloC from closing.
  bool canClose() => true;
}
