import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tbloc/tbloc.dart';

mixin BlocProviderSingleChildWidget on SingleChildWidget {}

/// Widget used as a dependency injection mechanism in order to provide to
/// multiple widgets a single instance of a BloC.
class BlocProvider<T extends Bloc<S>, S extends BlocState>
    extends SingleChildStatelessWidget with BlocProviderSingleChildWidget {
  // Dispose function used to dispose the bloc.
  final Dispose<T>? _dispose;

  // Function used to create the bloc.
  final Create<T>? _create;

  // Lazy flag used to determine if the bloc should be created lazily.
  final bool _lazy;

  BlocProvider({
    required T bloc,
    Dispose<T>? dispose,
    Widget? child,
    Key? key,
  }) : this._(
          create: (_) => bloc,
          dispose: dispose,
          child: child,
          key: key,
        );

  BlocProvider.lazy({
    required Create<T> create,
    Dispose<T>? dispose,
    Widget? child,
    Key? key,
  }) : this._(
          dispose: dispose,
          create: create,
          child: child,
          lazy: true,
          key: key,
        );

  BlocProvider._({
    required Create<T> create,
    bool lazy = false,
    Dispose<T>? dispose,
    super.child,
    super.key,
  })  : _create = create,
        _dispose = dispose,
        _lazy = lazy;

  static T of<T extends Bloc>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return InheritedProvider<T>(
      dispose: _dispose,
      create: _create,
      lazy: _lazy,
      child: child,
    );
  }
}

extension BlocProviderExtension on BuildContext {
  B bloc<B extends Bloc>() => BlocProvider.of<B>(this);
}
