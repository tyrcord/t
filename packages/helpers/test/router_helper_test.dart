import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:t_helpers/helpers.dart';

void main() {
  Widget defaultBuilder(context, state) => Container();

  group('GoRoute Comparison Tests', () {
    test('Routes with different lengths should be different', () {
      final routes1 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
      ];
      final routes2 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/settings', name: 'settings', builder: defaultBuilder),
      ];

      expect(areGoRoutesDifferent(routes1, routes2), isTrue);
    });

    test('Routes with same lengths but different paths should be different',
        () {
      final routes1 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/settings', name: 'settings', builder: defaultBuilder),
      ];
      final routes2 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/profile', name: 'profile', builder: defaultBuilder),
      ];

      expect(areGoRoutesDifferent(routes1, routes2), isTrue);
    });

    test(
        'Routes with same lengths and same paths but different '
        'names should be different', () {
      final routes1 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(
          path: '/settings',
          name: 'settingsPage',
          builder: defaultBuilder,
        ),
      ];
      final routes2 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/settings', name: 'settings', builder: defaultBuilder),
      ];

      expect(areGoRoutesDifferent(routes1, routes2), isTrue);
    });

    test('Identical routes should not be different', () {
      final routes1 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/settings', name: 'settings', builder: defaultBuilder),
      ];
      final routes2 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
        GoRoute(path: '/settings', name: 'settings', builder: defaultBuilder),
      ];

      expect(areGoRoutesDifferent(routes1, routes2), isFalse);
    });

    test(
        'Routes with same path and name but different builders '
        'should be different', () {
      final routes1 = [
        GoRoute(path: '/home', name: 'home', builder: defaultBuilder),
      ];
      final routes2 = [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const Text('Welcome Home'),
        ),
      ];

      expect(areGoRoutesDifferent(routes1, routes2), isTrue);
    });
  });
}
