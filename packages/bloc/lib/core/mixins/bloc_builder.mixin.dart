import 'package:flutter/material.dart';

import 'package:tbloc/tbloc.dart';

/// A mixin that provides to the [BlocBuilder] the ability to wait
/// for data before building.
class BlocBuilderMixin {
  /// Indicates if the [BlocBuilder] should wait for data.
  /// If `true`, the [BlocBuilder] will wait for data before
  /// building the widget.
  bool shouldWaitForData<S>(bool canWait, AsyncSnapshot<S> snapshot) {
    final state = snapshot.connectionState;

    return canWait &&
        (state == ConnectionState.waiting || state == ConnectionState.none);
  }

  /// Builds the loading widget if needed.
  Widget? buildLoadingWidgetIfNeeded<S>(
    BuildContext context,
    AsyncSnapshot<S> snapshot,
    IBlocBuilder widget,
  ) {
    if (shouldWaitForData(widget.waitForData, snapshot)) {
      if (widget.loadingBuilder != null) {
        return widget.loadingBuilder!(context);
      }

      return Container();
    }

    return null;
  }
}
