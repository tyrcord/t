// Flutter imports:
import 'package:flutter/widgets.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// A function that builds a widget based on the current [BlocState].
/// - [S] The [BlocState] type.
typedef BlocBuilder<S extends BlocState> = Widget Function(
  BuildContext context,
  S state,
);

/// A function that builds a widget based on two [BlocState]s.
/// - [S1] The first [BlocState] type.
/// - [S2] The second [BlocState] type.
typedef BlocBuilder2<S1 extends BlocState, S2 extends BlocState> = Widget
    Function(BuildContext context, S1 state, S2 state2);

/// A function that builds a widget based on three [BlocState]s.
/// - [S1] The first [BlocState] type.
/// - [S2] The second [BlocState] type.
/// - [S3] The third [BlocState] type.
typedef BlocBuilder3<S1 extends BlocState, S2 extends BlocState,
        S3 extends BlocState>
    = Widget Function(BuildContext context, S1 state, S2 state2, S3 state3);
