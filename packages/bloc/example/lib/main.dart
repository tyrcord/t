// ignore_for_file: lines_longer_than_80_chars

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'counter.bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      routesForMediaType: (mediaType) {
        return [
          GoRoute(
            builder: (context, state) => const MyHomePage(),
            path: '/',
          ),
        ];
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bloc = CounterBloc();

  @override
  void initState() {
    super.initState();

    bloc.addEvent(const CounterBlocEvent.init());
  }

  @override
  // ignore: long-method
  Widget build(BuildContext context) {
    return FastSectionPage(
      showAppBar: false,
      titleText: 'tBloc Demo',
      child: BlocProvider(
        bloc: bloc,
        child: Center(
          child: BlocBuilderWidget<CounterBlocState>(
            bloc: bloc,
            onlyWhenInitializing: true,
            builder: (context, state) {
              debugPrint(
                '_MyHomePageState: is building only if isInitializing or isInitialized have changed',
              );

              debugPrint('StatusWidget:isInitialized: ${state.isInitialized}');
              debugPrint(
                'StatusWidget:isInitializing: ${state.isInitializing}',
              );

              if (state.isInitialized) {
                return buildContent();
              }

              return const FastThreeBounceIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildActions(),
        kFastSizedBox16,
        const Text('You have pushed the button this many times:'),
        kFastSizedBox16,
        const CounterWidget(),
        kFastSizedBox16,
        const StatusWidget(),
      ],
    );
  }

  Widget buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FastRaisedButton(
          text: 'INCREMENT',
          onTap: () {
            bloc.addEvent(const CounterBlocEvent.increment());
          },
        ),
        FastRaisedButton(
          text: 'DECREMENT',
          onTap: () {
            bloc.addEvent(const CounterBlocEvent.decrement());
          },
        ),
        FastRaisedButton(
          text: 'RESET',
          onTap: () {
            bloc.addEvent(const CounterBlocEvent.reset());
          },
        ),
        FastRaisedButton(
          text: 'ERROR',
          onTap: () => bloc.addEvent(const CounterBlocEvent.error()),
        ),
      ],
    );
  }
}

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilderWidget(
      bloc: bloc,
      forceBuildWhenInializating: false,
      // forceBuildWhenBusy: false,
      buildWhen: (previous, next) {
        return previous.hasError != next.hasError;
      },
      builder: (BuildContext context, CounterBlocState state) {
        debugPrint(
          'StatusWidget: is building only if hasError or isBusy haved changed',
        );
        debugPrint('StatusWidget:hasError: ${state.hasError}');
        debugPrint('StatusWidget:isBusy: ${state.isBusy}');

        return Text(
          state.hasError ? state.error.toString() : 'No Error',
        );
      },
    );
  }
}

class CounterWidget extends StatelessWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilderWidget(
      bloc: bloc,
      builder: (BuildContext context, CounterBlocState state) {
        return Text(
          state.hasError ? state.error.toString() : '${state.counter}',
          style: Theme.of(context).textTheme.headlineMedium,
        );
      },
    );
  }
}
