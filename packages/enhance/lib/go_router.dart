import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  // Retrieve the current location of the router
  String location() {
    final currentMatch = _getLastRouteMatch();
    final matchList = _getRouteMatchList(currentMatch);

    return matchList.uri.toString();
  }

  // Get the last route match
  RouteMatch _getLastRouteMatch() {
    return routerDelegate.currentConfiguration.last;
  }

  // Determine the list of route matches
  RouteMatchList _getRouteMatchList(RouteMatch lastMatch) {
    if (lastMatch is ImperativeRouteMatch) {
      return lastMatch.matches;
    }

    return routerDelegate.currentConfiguration;
  }
}
