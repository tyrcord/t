import 'package:tbloc/tbloc.dart';

typedef BlocThrottleEventCallback<E extends BlocEvent> = void Function(E event);

typedef BlocThrottleCallback<E extends BlocEvent> = void Function([
  Map<dynamic, dynamic> extras,
]);

typedef BlocDebounceEventCallback<E extends BlocEvent> = void Function(E event);

typedef BlocDebounceCallback<E extends BlocEvent> = void Function([
  Map<dynamic, dynamic>? extras,
]);
