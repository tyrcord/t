// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:tbloc/tbloc.dart';

/// Merges multiple BlocProvider widgets into one widget tree.
class MultiBlocProvider extends StatelessWidget {
  /// The [BlocProvider] list which is merged into the widget tree.
  final List<BlocProviderSingleChildWidget> blocProviders;

  /// The [Widget] and its descendants which will have access to
  /// all the [Bloc]s.
  final Widget child;

  const MultiBlocProvider({
    super.key,
    required this.blocProviders,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: blocProviders,
      child: child,
    );
  }
}
