// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:async/async.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// Takes a Stream of BlocEvents as input and transforms them into a Stream of
/// BlocStates as output.
abstract class BidirectionalBloc<E extends BlocEvent, S extends BlocState>
    extends Bloc<S> {
  /// The internal event controller which is used to control the event stream.
  @protected
  final PublishSubject<BlocEvent> internalEventController =
      PublishSubject<BlocEvent>();

  /// The external event controller which is used to control the event stream.
  @protected
  final PublishSubject<E> externalEventController = PublishSubject<E>();

  /// The list of cancelable operations.
  @protected
  List<CancelableOperation> cancelableOperations = [];

  /// The event subscriptions.
  @protected
  late StreamSubscription<S> eventSubscriptions;

  /// The history map that stores the event-state history.
  @protected
  final Map<E, List<String>> eventStateHistory = {};

  /// The maximum size of the history. Set it to null to disable the limit.
  final int eventStateHistorySize;

  /// Enable force build events, if you want to force the rendering of the
  /// bloc builder.
  /// Indicates if the event-state history should be saved.
  final bool enableForceBuildEvents;

  /// Must be implemented when a class extends BidirectionalBloc.
  /// `mapEventToState` is called whenever an event is added and will convert
  /// that event into a new BloC state. It can yield zero, one or several states
  /// for an event.
  @protected
  Stream<S> mapEventToState(E event);

  /// Called whenever an event is added to the BloC.
  Stream<E> get onEvent => externalEventController.stream;

  /// Notifies the BloC of a new event which triggers `mapEventToState`.
  /// If `dispose` has already been called, any calls to `dispatchEvent`
  /// will be ignored and will not result in any state changes.
  ///
  /// For example:
  ///
  ///     bloc.dispatchEvent(blocEvent);
  Function(BlocEvent) get addEvent {
    // We should use a new Future (() => dispatch) in order to add the task
    // to the end of the event loop.

    if (!isClosed) {
      return internalEventController.sink.add;
    } else if (kDebugMode) {
      log('[$runtimeType]: try to dispatchEvent on a disposed bloc');
    }

    return _addEvent;
  }

  // ignore: no-empty-block
  void _addEvent(BlocEvent event) {}

  BidirectionalBloc({
    super.initialStateBuilder,
    super.initialState,
    this.eventStateHistorySize = 50,
    this.enableForceBuildEvents = false,
  }) {
    _handleEvents();
  }

  /// Determines whether a bloc ensures all `events` are processed in
  /// the order in which they are received.
  @protected
  bool shouldProcessEventInOrder() => true;

  /// Handles BloC events.
  void _handleEvents() {
    eventSubscriptions = _transformEvents().listen((S state) {
      setState(state);
    });
  }

  /// Transforms each event into a sequence of asynchronous events or will
  /// only use the very latest event according to the property
  /// `shouldProcessEventInOrder`.
  ///
  /// By default `asyncExpand` is used to ensure all `events` are processed in
  /// the order in which they are received.
  ///
  /// `switchMap` can be used if you want some scenarios to not complete.
  Stream<S> _transformEvents() {
    final source = internalEventController.where((_) => !isClosed);

    if (shouldProcessEventInOrder()) {
      return source.asyncExpand(_handleEvent);
    }

    return source.switchMap((BlocEvent event) {
      for (final operation in cancelableOperations) {
        operation.cancel();
      }

      return _handleEvent(event);
    });
  }

  /// Handles an BloC Event.
  Stream<S> _handleEvent(BlocEvent event) {
    if (event is E) {
      externalEventController.sink.add(event);

      final streamController = StreamController<S>.broadcast();
      final innerSubscription = mapEventToState(event)
          .where((S state) => !isClosed)
          .listen((S nextState) {
        updateEventStateHistory(event, nextState);
        blocState = nextState;
        streamController.add(nextState);
      })
        ..onDone(() => streamController.close())
        ..onError((dynamic error, StackTrace stackTrace) {
          if (!isClosed) {
            handleInternalError(error, stackTrace);
            final transformedError = transformError(error, stackTrace);

            if (transformedError != null) {
              errorController.sink.add(transformedError);
            }
          }

          streamController.close();
        });

      return streamController.stream.doOnDone(() {
        innerSubscription.cancel();
      });
    }

    return Stream.value(currentState);
  }

  /// Updates the event-state history.
  /// The event-state history is used to determine the event related to a
  /// given state.
  @protected
  void updateEventStateHistory(E event, S nextState) {
    if (enableForceBuildEvents) {
      if (eventStateHistory.length > eventStateHistorySize) {
        // Limit the event-state history map size
        final oldestEvent = eventStateHistory.keys.first;
        eventStateHistory.remove(oldestEvent);
      }

      if (eventStateHistorySize > 0) {
        // Update the event-state history
        final eventHistory = (eventStateHistory[event] ?? [])
          ..add(nextState.uuid);

        eventStateHistory[event] = eventHistory;
      }
    }
  }

  /// Returns the event related to the given [state].
  E? getEventForState(S state) {
    if (eventStateHistory.isEmpty ||
        eventStateHistorySize == 0 ||
        !enableForceBuildEvents) {
      return null;
    }

    for (final entry in eventStateHistory.entries) {
      final event = entry.key;
      final stateList = entry.value;

      if (stateList.contains(state.uuid)) {
        return event;
      }
    }

    return null;
  }

  /// Handles internal errors.
  @protected
  void handleInternalError(dynamic error, StackTrace stackTrace) {
    if (kDebugMode && !errorController.hasListener) {
      log('[$runtimeType]: Internal Bloc error not handled', error: error);
    }
  }

  /// Throttles an event. The event will be ignored if it is dispatched within
  /// the specified [duration]. The last event will be dispatched after the
  /// [duration] has passed.
  ///
  /// For example:
  ///
  ///      final throttled = throttleEvent((BlocEvent event) {
  ///          // heavy stuff
  ///      });
  BlocEventCallback<E> throttleEvent(
    BlocEventCallback<E> function, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    final throttler = PublishSubject<Tuple2<BlocEventCallback<E>, E>>();
    publishers.add(throttler);

    subxList.add(
      throttler
          .throttleTime(duration)
          .listen((Tuple2<BlocEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocEventCallback<E>, E>(function, event);
      throttler.add(tuple);
    };
  }

  /// Debounces an event. The [function] will not be invoked until [delay].
  ///
  /// For example:
  ///
  ///      final debounced = debounce((BlocEvent event) {
  ///          // heavy stuff
  ///      });
  BlocEventCallback<E> debounceEvent(
    BlocEventCallback<E> function, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    final debouncer = PublishSubject<Tuple2<BlocEventCallback<E>, E>>();
    publishers.add(debouncer);

    subxList.add(
      debouncer
          .debounceTime(delay)
          .listen((Tuple2<BlocEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocEventCallback<E>, E>(function, event);
      debouncer.add(tuple);
    };
  }

  BlocEventCallback<E> sampleEvent(
    BlocEventCallback<E> function, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    final sampler = PublishSubject<Tuple2<BlocEventCallback<E>, E>>();
    publishers.add(sampler);

    subxList.add(
      sampler.sampleTime(delay).listen((Tuple2<BlocEventCallback<E>, E> tuple) {
        tuple.item1(tuple.item2);
      }),
    );

    return (E event) {
      final tuple = Tuple2<BlocEventCallback<E>, E>(function, event);
      sampler.add(tuple);
    };
  }

  /// Performs an asynchronous operation and cancels it if the BloC is closed.
  @protected
  Future<T?> performCancellableAsyncOperation<T>(Future<T> opreation) {
    if (shouldProcessEventInOrder()) {
      return opreation;
    }

    final cancellableOperation = CancelableOperation<T>.fromFuture(opreation);
    cancelableOperations.add(cancellableOperation);

    return cancellableOperation.valueOrCancellation();
  }

  /// Closes the BloC.
  /// This method should be called when the BloC is no longer needed.
  @override
  @mustCallSuper
  void close() {
    if (!closed && canClose()) {
      super.close();

      internalEventController.close();
      externalEventController.close();
      eventSubscriptions.cancel();
    }
  }
}
