import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tbloc/tbloc.dart';

/// Handles building a widget when two BloC states change.
class BlocBuilderWidget2<S1 extends BlocState, S2 extends BlocState>
    extends StatefulWidget implements IBlocBuilder {
  /// The function that builds the widget based on the two [BlocState]s.
  final BlocBuilder2<S1, S2> builder;

  /// The first [Bloc] to listen to.
  final Bloc<S1> bloc1;

  /// The second [Bloc] to listen to.
  final Bloc<S2> bloc2;

  /// The widget to show while waiting for data.
  @override
  final WidgetBuilder? loadingBuilder;

  /// Whether to wait for data before building the widget.
  @override
  final bool waitForData;

  const BlocBuilderWidget2({
    super.key,
    required this.builder,
    required this.bloc1,
    required this.bloc2,
    this.waitForData = false,
    this.loadingBuilder,
  });

  @override
  BlocBuilderWidget2State<S1, S2> createState() =>
      BlocBuilderWidget2State<S1, S2>();
}

class BlocBuilderWidget2State<S1 extends BlocState, S2 extends BlocState>
    extends State<BlocBuilderWidget2<S1, S2>> with BlocBuilderMixin {
  late Stream<List<BlocState>> _stream;

  @override
  void initState() {
    super.initState();
    _buildStream();
  }

  @override
  void didUpdateWidget(BlocBuilderWidget2<S1, S2> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bloc1 != widget.bloc1 || oldWidget.bloc2 != widget.bloc2) {
      _buildStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BlocState>>(
      stream: _stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<BlocState>> snapshot,
      ) {
        final loading = buildLoadingWidgetIfNeeded(context, snapshot, widget);

        if (loading != null) {
          return loading;
        }

        final data = snapshot.data;
        final state1 = data != null ? data[0] as S1 : null;
        final state2 = data != null ? data[1] as S2 : null;

        return widget.builder(
          context,
          state1 ?? widget.bloc1.currentState,
          state2 ?? widget.bloc2.currentState,
        );
      },
    );
  }

  void _buildStream() {
    _stream = CombineLatestStream.combine2<S1, S2, List<BlocState>>(
      widget.bloc1.onData,
      widget.bloc2.onData,
      (S1 a, S2 b) => [a, b],
    );
  }
}
