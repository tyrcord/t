import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';
import 'package:flutter/material.dart';
import 'counter.bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FastApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bloc = CounterBloc();

  @override
  void initState() {
    super.initState();

    bloc.addEvent(CounterBlocEvent.init());
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

              return FastThreeBounceIndicator();
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
        Text('You have pushed the button this many times:'),
        kFastSizedBox16,
        CounterWidget(),
        kFastSizedBox16,
        StatusWidget(),
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
            bloc.addEvent(CounterBlocEvent.increment());
          },
        ),
        FastRaisedButton(
          text: 'DECREMENT',
          onTap: () {
            bloc.addEvent(CounterBlocEvent.decrement());
          },
        ),
        FastRaisedButton(
          text: 'RESET',
          onTap: () {
            bloc.addEvent(CounterBlocEvent.reset());
          },
        ),
        FastRaisedButton(
          text: 'ERROR',
          onTap: () => bloc.addEvent(CounterBlocEvent.error()),
        ),
      ],
    );
  }
}

class StatusWidget extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterBloc>(context);

    return BlocBuilderWidget(
      bloc: bloc,
      builder: (BuildContext context, CounterBlocState state) {
        return Text(
          state.hasError ? state.error.toString() : '${state.counter}',
          style: Theme.of(context).textTheme.headline4,
        );
      },
    );
  }
}
