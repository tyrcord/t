import 'package:go_router/go_router.dart';

/// Compares two lists of [GoRoute] to determine if they are different.
///
/// The comparison is based on the length of the route lists and the properties
/// of the individual routes, specifically the 'path' and 'name'.
///
/// Args:
///   routes1 (List<GoRoute>): The first list of GoRoute objects.
///   routes2 (List<GoRoute>): The second list of GoRoute objects.
///
/// Returns:
///   bool: True if the routes are different, False otherwise.
bool areGoRoutesDifferent(List<GoRoute> routes1, List<GoRoute> routes2) {
  // Check if the lengths of the route lists are different
  if (routes1.length != routes2.length) {
    return true;
  }

  // Compare corresponding routes from both lists
  for (int index = 0; index < routes1.length; index++) {
    if (!_areGoRoutesEqual(routes1[index], routes2[index])) {
      return true;
    }
  }

  return false;
}

/// Compares two [GoRoute] objects to determine if they are equal.
///
/// Equality is based on the 'path' and 'name' properties of the routes.
///
/// Args:
///   route1 (GoRoute): The first GoRoute object.
///   route2 (GoRoute): The second GoRoute object.
///
/// Returns:
///   bool: True if the routes are equal, False otherwise.
bool _areGoRoutesEqual(GoRoute route1, GoRoute route2) {
  return route1.path == route2.path &&
      route1.name == route2.name &&
      route1.builder == route2.builder;
}
