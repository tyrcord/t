// Project imports:
import 'package:tbloc/tbloc.dart';

typedef BlocThrottleCallback<E extends BlocEvent> = void Function([
  Map<dynamic, dynamic> extras,
]);

typedef BlocDebounceCallback<E extends BlocEvent> = void Function([
  Map<dynamic, dynamic>? extras,
]);

typedef BlocEventCallback<E extends BlocEvent> = void Function(E event);
