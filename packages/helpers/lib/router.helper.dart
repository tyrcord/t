import 'package:go_router/go_router.dart';

/// Compares two lists of [RouteBase] to determine if they are different.
///
/// Args:
///   routes1 (List<RouteBase>): The first list of RouteBase objects.
///   routes2 (List<RouteBase>): The second list of RouteBase objects.
///
/// Returns:
///   bool: True if the routes are different, False otherwise.
bool areRouteBasesDifferent(List<RouteBase> routes1, List<RouteBase> routes2) {
  // Check if the lengths of the route lists are different
  if (routes1.length != routes2.length) {
    return true;
  }

  // Compare corresponding routes from both lists
  for (int index = 0; index < routes1.length; index++) {
    if (!_areRouteBasesEqual(routes1[index], routes2[index])) {
      return true;
    }
  }

  return false;
}

/// Compares two [RouteBase] objects to determine if they are equal.
bool _areRouteBasesEqual(RouteBase route1, RouteBase route2) {
  if (route1 is GoRoute && route2 is GoRoute) {
    return route1.path == route2.path &&
        route1.name == route2.name &&
        route1.builder == route2.builder &&
        route1.redirect == route2.redirect &&
        route1.pageBuilder == route2.pageBuilder &&
        route1.parentNavigatorKey == route2.parentNavigatorKey;
  } else if (route1 is ShellRoute && route2 is ShellRoute) {
    return route1.builder == route2.builder &&
        route1.parentNavigatorKey == route2.parentNavigatorKey &&
        route1.pageBuilder == route2.pageBuilder &&
        route1.navigatorKey == route2.navigatorKey &&
        areRouteBasesDifferent(route1.routes, route2.routes);
  }

  return route1.runtimeType == route2.runtimeType;
}
