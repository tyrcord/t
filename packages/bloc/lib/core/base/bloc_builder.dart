import 'package:flutter/material.dart';

import 'package:tbloc/tbloc.dart';

/// Handles building a widget when BloC's state changes.
class BlocBuilderWidget<S extends BlocState> extends StatefulWidget
    implements IBlocBuilder {
  /// A function that indicates whether the widget should be rebuilt.
  final bool Function(S previous, S next)? buildWhen;

  /// A function that builds a widget based on the [BlocState].
  final BlocBuilder<S> builder;

  /// The [Bloc] that the widget will listen to.
  final Bloc<S> bloc;

  /// A function that builds a widget when the [Bloc] is loading.
  @override
  final WidgetBuilder? loadingBuilder;

  /// Indicates whether the widget should wait for data before building.
  @override
  final bool waitForData;

  /// Indicates whether the widget should be rebuilt when the [Bloc] is
  /// initializing.
  /// Must be used with [buildWhen] to work properly.
  final bool forceBuildWhenInializating;

  /// Indicates whether the widget should be rebuilt when the [Bloc] is busy.
  /// Must be used with [buildWhen] to work properly.
  final bool forceBuildWhenBusy;

  /// Indicates whether the widget should only be built when the [Bloc] is
  /// initializing.
  final bool onlyWhenInitializing;

  /// Indicates whether the widget should only be built when the [Bloc] is busy.
  final bool onlyWhenBusy;

  const BlocBuilderWidget({
    super.key,
    required this.builder,
    required this.bloc,
    this.forceBuildWhenInializating = true,
    this.onlyWhenInitializing = false,
    this.forceBuildWhenBusy = true,
    this.onlyWhenBusy = false,
    this.waitForData = false,
    this.loadingBuilder,
    this.buildWhen,
  });

  @override
  BlocBuilderWidgetState<S> createState() => BlocBuilderWidgetState<S>();
}

class BlocBuilderWidgetState<S extends BlocState>
    extends State<BlocBuilderWidget<S>> with BlocBuilderMixin {
  late Stream<S> _stream;

  @override
  void initState() {
    super.initState();
    _buildStream();
  }

  @override
  void didUpdateWidget(BlocBuilderWidget<S> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bloc != widget.bloc ||
        oldWidget.buildWhen != widget.buildWhen) {
      _buildStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: widget.bloc.currentState,
      stream: _stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<S> snapshot,
      ) {
        final loading = buildLoadingWidgetIfNeeded(context, snapshot, widget);

        if (loading != null) {
          return loading;
        }

        return widget.builder(context, snapshot.data!);
      },
    );
  }

  // Build the stream based on the [buildWhen] function.
  // If [buildWhen] is null, the stream will be the [Bloc.onData] stream.
  // If [buildWhen] is not null, the stream will be the [Bloc.onData] stream
  // filtered by the [buildWhen] function.
  void _buildStream() {
    S? previousState;
    S? nextState;

    _stream = widget.buildWhen == null
        ? widget.bloc.onData.distinct((S previous, S next) {
            // FIXME: Need investigation
            // Woraround for not getting the previous state.
            if (previousState == null) {
              previousState = previous;
              nextState = next;
            } else {
              previousState = nextState;
              nextState = next;
            }

            if (widget.onlyWhenInitializing) {
              return !_hasBlocInitializationChanged(previousState!, nextState!);
            }

            if (widget.onlyWhenBusy) {
              return !_hasBlocBecomeBusy(previousState!, nextState!);
            }

            return false;
          })
        : widget.bloc.onData.distinct((S previous, S next) {
            // FIXME: Need investigation
            // Woraround for not getting the previous state.
            if (previousState == null) {
              previousState = previous;
              nextState = next;
            } else {
              previousState = nextState;
              nextState = next;
            }

            if (widget.forceBuildWhenInializating &&
                _hasBlocInitializationChanged(previousState!, nextState!)) {
              return false;
            }

            if (widget.forceBuildWhenBusy &&
                _hasBlocBecomeBusy(previousState!, nextState!)) {
              return false;
            }

            return !widget.buildWhen!(previousState!, nextState!);
          });
  }

  bool _hasBlocInitializationChanged(S previous, S next) {
    return previous.isInitialized != next.isInitialized ||
        previous.isInitializing != next.isInitializing;
  }

  bool _hasBlocBecomeBusy(S previous, S next) {
    return previous.isBusy != next.isBusy;
  }
}
